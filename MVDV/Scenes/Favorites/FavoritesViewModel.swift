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
    case fetch
    case showMovieDetail(Movie)
}

enum FavoritesEvent {
    case alert(String)
}

enum FavoritesMutation {
    case fetching(Bool)
    case favorites([Movie])
}

struct FavoritesState {
    struct Sections {
        var favorites: [Movie] = []
    }
    
    @Driving var fetching = false
    @Driving var authenticated = false
    @Driving var sections = Sections()
}

final class FavoritesViewModel: ViewModel<FavoritesAction, FavoritesMutation, FavoritesEvent, FavoritesState> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let coordinator: FavoritesCoordinator
    let dataStorage: DataStorage
    
    init(imageConfiguration: ImageConfiguration, coordinator: FavoritesCoordinator, dataStorage: DataStorage = DataStorage.shared) {
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
        self.coordinator = coordinator
        self.dataStorage = dataStorage
        
        let state = State(fetching: false,
                          authenticated: dataStorage.authenticated,
                          sections: .init(favorites: []))
        
        super.init(state: state,
                   actionMiddlewares: actionMiddlewares,
                   eventMiddlewares: eventMiddlewares)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .fetch:
            return fetch()
        case .showMovieDetail(let movie):
            coordinator.showDetail(movie: movie, imageConfiguration: imageConfiguration)
            return .empty()
        }
    }
    
    override func reduce(mutation: Mutation, state: State) -> State {
        var state = state
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .favorites(let movies):
            state.sections.favorites = movies
        }
        return state
    }
}

extension FavoritesViewModel {
    func fetch() -> Observable<Reaction> {
        guard let sessionId = dataStorage.authentication?.sessionId,
              let accountId = dataStorage.authentication?.accountId
        else {
            return .just(.event(.alert(Strings.Common.notAuthenticatedYet)))
        }
        
        return MVDVService.shared.account.favoritesMovies(sessionId: sessionId, accountId: accountId)
            .map {
                Reaction.mutation(.favorites($0.results))
            }
            .catch { .just(.event(.alert($0.localizedDescription))) }
            .startWith(Reaction.mutation(.fetching(true)))
            .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
    }
}
