//
//  HomeViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/26.
//

import Foundation
import Reduxift
import RxSwift

enum HomeAction: ViewModelAction {
    case ready
    case movie
}

enum HomeEvent: ViewModelEvent {
    case alert(String)
}

enum HomeMutation: ViewModelMutation {
    case fetching(Bool)
    case sections(HomeState.Sections)
}

struct HomeState: ViewModelState {
    struct Sections {
        var nowPlaying: [Movie] = []
        var genres: [Genre] = []
        var trending: [Movie] = []
        var popuplar: [Movie] = []
        var topRated: [Movie] = []
    }
    
    @Driving var fetching: Bool = false
    @Driving var sections: Sections = .init()
}

final class HomeViewModel: ViewModel<HomeAction, HomeMutation, HomeState, HomeEvent> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    
    init(imageConfiguration: ImageConfiguration, state initialState: HomeState = HomeState()) {
        let actionMiddlewares = [
            Self.middleware.action { state, next, action in
                print("[ACTION] \(action)")
                return next(action)
            }
        ]
        
        let mutationMiddlewares = [
            Self.middleware.mutation { state, next, mutation in
                print("[MUTATION] \(mutation)")
                return next(mutation)
            }
        ]
        
        let eventMiddlewares = [
            Self.middleware.event { state, next, event in
                print("[EVENT] \(event)")
                return next(event)
            }
        ]
        
        let stateMiddlewares = [
            Self.middleware.state { state, next in
                print("[STATE] \(state)")
                return next(state)
            }
        ]
        
        self.imageConfiguration = imageConfiguration
        
        super.init(state: initialState,
                   actionMiddlewares: actionMiddlewares,
                   /*mutationMiddlewares: mutationMiddlewares,*/
                   eventMiddlewares: eventMiddlewares/*,
                   stateMiddlewares: stateMiddlewares*/)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
            case .ready:
                // TODO: catch individual errors
                return Observable.combineLatest(APIService.shared.configuration(),
                                                APIService.shared.trending(),
                                                APIService.shared.genres(),
                                                APIService.shared.topRated(),
                                                APIService.shared.popular(),
                                                APIService.shared.nowPlaying())
                    .flatMap { (configuration, trending, genres, topRated, popular, nowPlaying) -> Observable<Reaction> in
                        let section = State.Sections(nowPlaying: nowPlaying.results,
                                                     genres: genres.genres,
                                                     trending: trending.results,
                                                     popuplar: popular.results,
                                                     topRated: topRated.results)
                        return .just(.mutation(.sections(section)))
                    }
                    .catch { _ in
                        .just(.event(.alert("Network error")))
                    }
                    .startWith(Reaction.mutation(.fetching(true)))
                    .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
            case .movie:
                // TODO: transition to movie detail
                print("TODOP: Show movie detail")
                return .empty()
        }
    }
    
    override func reduce(mutation: Mutation, state: State) -> State {
        var state = state
        switch mutation {
            case .fetching(let fetching):
                state.fetching = fetching
            case .sections(let sections):
                state.sections = sections
        }
        return state
    }
}
