//
//  MainViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/15.
//

import Foundation
import RDXVM
import RxSwift

enum MainAction: ViewModelAction {
    case ready
}

enum MainEvent: ViewModelEvent {
    case alert(String)
}

enum MainMutation: ViewModelMutation {
    case fetching(Bool)
    case imageConfiguration(ImageConfiguration)
}

struct MainState: ViewModelState {
    @Driving var fetching: Bool = false
    @Driving var imageConfiguration: ImageConfiguration?
}

final class MainViewModel: ViewModel<MainAction, MainMutation, MainState, MainEvent> {
    private(set) var db = DisposeBag()
    
    init(state initialState: State = State()) {
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
        
        super.init(state: initialState,
                   actionMiddlewares: actionMiddlewares,
                   eventMiddlewares: eventMiddlewares)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .ready:
            // TODO: catch individual errors
            return MVDVService.shared.configuration()
                .map {
                    .mutation(.imageConfiguration($0.images))
                }
                .catch { _ in
                    .just(.event(.alert("Configuration unavailable")))
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
        case .imageConfiguration(let imageConfiguration):
            state.imageConfiguration = imageConfiguration
        }
        return state
    }
}
