//
//  FavoritesViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/28.
//

import Foundation
import RDXVM
import RxSwift
import AuthenticationServices

enum FavoritesAction {
    case authenticate(ASWebAuthenticationPresentationContextProviding)
    case unauthenticate
    case fetch
}

enum FavoritesEvent {
    case alert(String)
}

enum FavoritesMutation {
    case fetching(Bool)
    case authenticated(Bool)
    case sections(FavoritesState.Sections)
}

struct FavoritesState {
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
            return authenticate(providing)
            
        case .unauthenticate:
            return unauthenticate()
            
        case .fetch:
            return fetch()
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
    
    override func transform(action: Observable<Action>) -> Observable<Action> {
        // relays events of AppModel to action
        let authenticated = AppModel.shared.event
            .asObservable()
            .flatMap { event -> Observable<Action> in
                switch event {
                case .authenticated:
                    return .just(Action.fetch)
                default:
                    return .empty()
                }
            }
            .observe(on: MainScheduler.asyncInstance) ///< Avoid conflicting with 'fetching' state of AppModel
        
        return .merge(action,
                      authenticated)
    }
    
    override func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        // relays some state of AppModel to mutation
        
        let fetching = AppModel.shared.state.$fetching
            .distinctUntilChanged()
            .map { Mutation.fetching($0) }
            .asObservable()
        
        let authenticated = AppModel.shared.state.$authenticated
            .map { Mutation.authenticated($0) }
            .asObservable()
        
        return .merge(mutation,
                      fetching,
                      authenticated)
    }
        
    override func transform(error: Observable<Error>) -> Observable<Error> {
        .merge(error, AppModel.shared.error.asObservable())
    }
}

extension FavoritesViewModel {
    func authenticate(_ providing: ASWebAuthenticationPresentationContextProviding) -> Observable<Reaction> {
        AppModel.shared.send(action: .authenticate(providing))
        return .empty()
    }
    
    func unauthenticate() -> Observable<Reaction> {
        AppModel.shared.send(action: .unauthenticate)
        return .empty()
    }
    
    func fetch() -> Observable<Reaction> {
        guard let sessionId = dataStorage.authentication?.sessionId,
              let accountId = dataStorage.authentication?.accountId
        else {
            return .just(.event(.alert("Not authenticated yet")))
        }
        
        return MVDVService.shared.account.favoritesMovies(sessionId: sessionId, accountId: accountId)
            .map {
                Reaction.mutation(.sections(.init(movies: $0.results)))
            }
            .catch { .just(.event(.alert($0.localizedDescription))) }
            .startWith(Reaction.mutation(.fetching(true)))
            .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
    }
}
