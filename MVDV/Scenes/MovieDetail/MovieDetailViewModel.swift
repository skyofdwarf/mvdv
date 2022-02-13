//
//  MovieDetailViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/03.
//

import Foundation
import Reduxift
import RxSwift

enum MovieDetailAction: ViewModelAction {
    case ready
}

enum MovieDetailEvent: ViewModelEvent {
    case alert(String)
}

enum MovieDetailMutation: ViewModelMutation {
    case fetching(Bool)
    case detail(MovieDetailResponse)
}

struct MovieDetailState: ViewModelState {
    @Driving var fetching: Bool = false
    @Driving var detail: MovieDetailResponse? = nil
    @Driving var backdrop: URL?
}

final class MovieDetailViewModel: ViewModel<MovieDetailAction, MovieDetailMutation, MovieDetailState, MovieDetailEvent> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let movieId: Int
    let backdrop: URL    
    
    init(imageConfiguration: ImageConfiguration, movieId: Int, backdrop: URL) {
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
        self.movieId = movieId
        self.backdrop = backdrop
        
        let state = State(fetching: false,
                          detail: nil,
                          backdrop: backdrop)
        
        super.init(state: state,
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
                return APIService.shared.detail(id: movieId)
                    .map { detail -> Reaction in
                        .mutation(.detail(detail))
                    }
                    .catch {
                        .from([.mutation(.fetching(false)),
                               .event(.alert($0.localizedDescription))])
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
            case .detail(let detail):
                state.detail = detail
        }
        return state
    }
}
