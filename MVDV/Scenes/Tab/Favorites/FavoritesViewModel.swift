//
//  FavoritesViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/28.
//

import Foundation
import Reduxift
import RxSwift
import AuthenticationServices

enum FavoritesAction: ViewModelAction {
    case authenticate(ASWebAuthenticationPresentationContextProviding?)
    case fetch
}

enum FavoritesEvent: ViewModelEvent {
    case alert(String)
}

enum FavoritesMutation: ViewModelMutation {
    case fetching(Bool)
    case authenticated(Bool)
    case sections(FavoritesState.Sections)
}

struct FavoritesState: ViewModelState {
    struct Sections {
        var movies: [Movie] = []
    }
    
    @Driving var fetching = false
    @Driving var authenticated = false
    @Driving var sections = Sections()
}

final class FavoritesViewModel: ViewModel<FavoritesAction, FavoritesMutation, FavoritesState, FavoritesEvent> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let dataStorage: DataStorage
    
    init(imageConfiguration: ImageConfiguration, dataStorage: DataStorage = DataStorage.shared) {
        let actionMiddlewares = [
            Self.middleware.action { state, next, action in
                print("[ACTION] \(action)")
                return next(action)
            }
        ]
        
        let eventMiddlewares = [
            Self.middleware.event { state, next, event in
                print("[EVENT] \(event)")
                return next(event)
            }
        ]

        self.imageConfiguration = imageConfiguration
        self.dataStorage = dataStorage
        
        let state = State(fetching: false,
                          authenticated: dataStorage.authenticated,
                          sections: .init())
        
        super.init(state: state,
                   actionMiddlewares: actionMiddlewares,
                   /*mutationMiddlewares: mutationMiddlewares,*/
                   eventMiddlewares: eventMiddlewares/*,
                   stateMiddlewares: stateMiddlewares*/)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .authenticate(let providing):
            return authenticate(providing: providing)
        case .fetch:
            return getFavorites(dataStorage: dataStorage)
        }
    }
    
    override func reduce(mutation: Mutation, state: State) -> State {
        var state = state
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .authenticated(let authenticated):
            state.authenticated = authenticated
        case .sections(let sections):
            state.sections = sections
        }
        return state
    }
}

extension FavoritesViewModel {
    func authenticate(providing: ASWebAuthenticationPresentationContextProviding?) -> Observable<Reaction> {
        // authenticate user
        return MVDVService.shared.authentication.authenticate(providing: providing)
            .withUnretained(dataStorage)
            .flatMap { dataStorage, newSessionResponse in
                // get account detail
                let sessionId: String = newSessionResponse.session_id
                return MVDVService.shared.account.account(sessionId: sessionId)
                    .withUnretained(dataStorage)
                    .do(onNext: { storage, account in
                        // save account and session data
                        try storage.saveAccount(accountId: account.username, sessionId: sessionId, gravatarHash: account.avatar?.gravatar?.hash)
                    })
                    // TODO: The reaction should be able to return another action not only a mutation or an event.
                    // .map {
                    //     Reaction.action(.fetch)
                    // }
                    .flatMap { [weak self] storage, _ in
                        return self?.getFavorites(dataStorage: storage)
                            .startWith(Reaction.mutation(.authenticated(true)))
                        ?? .empty()
                    }
            }
            .catch {
                .just(Reaction.event(.alert($0.localizedDescription)))
            }
            .startWith(Reaction.mutation(.fetching(true)))
            .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
    }
    
    func getFavorites(dataStorage: DataStorage) -> Observable<Reaction> {
        guard let sessionId = dataStorage.sessionId,
              let accountId = dataStorage.accountId
        else {
            return .just(.event(.alert("Not authenticated yet")))
        }
        
        return MVDVService.shared.account.favoritesMovies(sessionId: sessionId, accountId: accountId)
            .map {
                Reaction.mutation(.sections(.init(movies: $0.results)))
            }
            .startWith(Reaction.mutation(.fetching(true)))
            .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
    }
}
