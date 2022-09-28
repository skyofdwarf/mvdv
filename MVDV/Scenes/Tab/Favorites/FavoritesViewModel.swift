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
//    case fetch
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
        case .authenticate(let providing):
            return MVDVService.shared.authentication.authenticate(providing: providing)
                .map { Reaction.event(.alert($0.session_id)) }
                .catch {
                    .just(Reaction.event(.alert($0.localizedDescription)))
                }
                .startWith(Reaction.mutation(.fetching(true)))
                .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
        }
    }
    
    override func reduce(mutation: Mutation, state: State) -> State {
//        var state = state
//        switch mutation {
//        case .fetching(let fetching):
//            state.fetching = fetching
//        case .query(let query):
//            state.query = query
//        case .sections(let sections):
//            state.sections = sections
//        }
        return state
    }
}
