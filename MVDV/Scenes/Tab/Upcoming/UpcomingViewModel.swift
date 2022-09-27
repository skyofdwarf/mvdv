//
//  UpcomingViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/15.
//

import Foundation
import Reduxift
import RxSwift

enum UpcomingAction: ViewModelAction {
    case ready
}

enum UpcomingEvent: ViewModelEvent {
    case alert(String)
}

enum UpcomingMutation: ViewModelMutation {
    case fetching(Bool)
    case sections(UpcomingState.Sections)
}

struct UpcomingState: ViewModelState {
    struct Sections {
        var movies: [Movie] = []
    }
    
    @Driving var fetching: Bool = false
    @Driving var sections: Sections = .init()
}

final class UpcomingViewModel: ViewModel<UpcomingAction, UpcomingMutation, UpcomingState, UpcomingEvent> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    
    init(imageConfiguration: ImageConfiguration) {
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
