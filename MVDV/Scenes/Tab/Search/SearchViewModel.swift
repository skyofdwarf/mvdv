//
//  SearchViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/19.
//

import Foundation
import RDXVM
import RxSwift

enum SearchAction {
    case search(query: String?)
    case showMovieDetail(Movie)
}

enum SearchEvent {
    case alert(String)
}

enum SearchMutation {
    case fetching(Bool)
    case query(String?)
    case sections(SearchState.Sections)
}

struct SearchState {
    struct Sections {
        var movies: [Movie] = []
    }
    
    @Driving var fetching: Bool = false
    @Driving var query: String? = nil
    @Driving var sections: Sections = .init()
}

final class SearchViewModel: ViewModel<SearchAction, SearchMutation, SearchState, SearchEvent> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let coordinator: SearchCoordinator
    
    init(imageConfiguration: ImageConfiguration, coordinator: SearchCoordinator) {
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
        
        super.init(state: State(),
                   actionMiddlewares: actionMiddlewares,
                   /*mutationMiddlewares: mutationMiddlewares,*/
                   eventMiddlewares: eventMiddlewares/*,
                   stateMiddlewares: stateMiddlewares*/)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .search(let query):
            guard let query else {
                let sections = State.Sections(movies: [])
                return .of(.mutation(.query(query)),
                           .mutation(.sections(sections)))
            }
            
            return MVDVService.shared.movie.search(query: query)
                .map { response -> Reaction in
                    let sections = State.Sections(movies: response.results)
                    return .mutation(.sections(sections))
                }
                .catch {
                    .just(.event(.alert($0.localizedDescription)))
                }
                .startWith(Reaction.mutation(.fetching(true)))
                .startWith(Reaction.mutation(.query(query)))
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
        case .query(let query):
            state.query = query
        case .sections(let sections):
            state.sections = sections
        }
        return state
    }
}

