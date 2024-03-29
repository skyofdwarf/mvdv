//
//  UpcomingViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/15.
//

import Foundation
import RDXVM
import RxSwift

enum UpcomingAction {
    case ready
    case showMovieDetail(Movie)
}

enum UpcomingEvent {
    case alert(String)
}

enum UpcomingMutation {
    case fetching(Bool)
    case sections(UpcomingState.Sections)
}

struct UpcomingState {
    struct Sections {
        var movies: [Movie] = []
    }
    
    @Drived var fetching: Bool = false
    @Drived var sections: Sections = .init()
}

final class UpcomingViewModel: ViewModel<UpcomingAction, UpcomingMutation, UpcomingEvent, UpcomingState> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let coordinator: UpcomingCoordinator
    
    init(imageConfiguration: ImageConfiguration, coordinator: UpcomingCoordinator) {
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
        case .ready:
            // TODO: fetch all movies
            return MVDVService.shared.movie.upcoming()
                .map { upcoming -> Reaction in
                    let sections = State.Sections(movies: upcoming.results)
                    return .mutation(.sections(sections))
                }
                .catch {
                    .just(.event(.alert($0.localizedDescription)))
                }
                .startWith(Reaction.mutation(.fetching(true)))
                .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
        case .showMovieDetail(let movie):
            coordinator.showDetail(movie: movie, imageConfiguration: imageConfiguration)
            return .empty()
        }
    }
    
    override func reduce(mutation: Mutation, state: inout State) {
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .sections(let sections):
            state.sections = sections
        }
    }
}
