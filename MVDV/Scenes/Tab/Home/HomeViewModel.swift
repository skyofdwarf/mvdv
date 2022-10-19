//
//  HomeViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/26.
//

import Foundation
import RDXVM
import RxSwift

enum HomeAction {
    case ready
    case showMovieDetail(Movie)
}

enum HomeEvent {
    case alert(String)
}

enum HomeMutation {
    case fetching(Bool)
    case sections(HomeState.Sections)
}

struct HomeState {
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

final class HomeViewModel: ViewModel<HomeAction, HomeMutation, HomeEvent, HomeState> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let coordinator: HomeCoordinator
    
    init(imageConfiguration: ImageConfiguration, coordinator: HomeCoordinator) {
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
            Self.postware.state { state, next in
                print("[STATE] \(state)")
                return next(state)
            }
        ]
        
        self.imageConfiguration = imageConfiguration
        self.coordinator = coordinator
        
        super.init(state: State(),
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
            return Observable.combineLatest(MVDVService.shared.movie.trending(),
                                            MVDVService.shared.movie.genres(),
                                            MVDVService.shared.movie.topRated(),
                                            MVDVService.shared.movie.popular(),
                                            MVDVService.shared.movie.nowPlaying())
                .flatMap { (trending, genres, topRated, popular, nowPlaying) -> Observable<Reaction> in
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
        case .sections(let sections):
            state.sections = sections
        }
        return state
    }
}
