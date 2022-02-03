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
    case alert
}

enum HomeMutation: ViewModelMutation {
    case fetching(Bool)
    case imageConfiguration(ImageConfiguration)
    case data([HomeSection: [HomeItem]])
}

enum HomeSection: Int, CaseIterable {
    case nowPlaying
    case genres
    case trending
    case popuplar
    case topRated
    
    var title: String {
        switch self {
            case .nowPlaying: return "Now Playing"
            case .genres: return "Genres"
            case .trending: return "Trending"
            case .popuplar: return "Popular"
            case .topRated: return "Top Rated"
        }
    }
}

enum HomeItem: Hashable {
    case genre(Genre)
    case movie(Movie)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.genre(r), .genre(l)):
                return r == l
            case let (.movie(r), .movie(l)):
                return r == l
            default:
                return false
        }
    }
}

struct HomeState: ViewModelState {
    @Driving var fetching: Bool = false
    @Driving var data: [HomeSection: [HomeItem]] = [:]
    
    var imageConfiguration = ImageConfiguration()
}

final class HomeViewModel: ViewModel<HomeAction, HomeMutation, HomeState, HomeEvent> {
    private(set) var db = DisposeBag()
    
    init(state initialState: HomeState = HomeState()) {
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
                // TODO: fetch all movies
                return Observable.combineLatest(APIService.shared.configuration(),
                                                APIService.shared.trending(),
                                                APIService.shared.genres(),
                                                APIService.shared.topRated(),
                                                APIService.shared.popular(),
                                                APIService.shared.nowPlaying())
                    .flatMap { (configuration, trending, genres, topRated, popular, nowPlaying) -> Observable<Reaction> in
                        let data: [HomeSection: [HomeItem]] = [ .genres: genres.genres.map(HomeItem.genre),
                                                                .trending: trending.results.map(HomeItem.movie),
                                                                .nowPlaying: nowPlaying.results.map(HomeItem.movie),
                                                                .popuplar: popular.results.map(HomeItem.movie),
                                                                .topRated: topRated.results.map(HomeItem.movie) ]
                        return .from([.mutation(.imageConfiguration(configuration.images)),
                                      .mutation(.data(data))])
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
            case .imageConfiguration(let imageConfiguration):
                state.imageConfiguration = imageConfiguration
            case .data(let data):
                state.data = data
        }
        return state
    }
}
