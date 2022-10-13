//
//  MovieDetailViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/03.
//

import Foundation
import RDXVM
import RxSwift

enum MovieDetailAction {
    case ready
    case toggleFavorite
}

enum MovieDetailEvent: CustomStringConvertible {
    case alert(String)
    case notAuthenticated
    
    var description: String {
        switch self {
        case .alert(let msg): return msg
        case .notAuthenticated: return "Not authenticated yet"
        }
    }
}

enum MovieDetailMutation {
    case fetching(Bool)
    case favorited(Bool)
    case sections(MovieDetailState.Sections)
}

struct MovieDetailState {
    struct Sections {
        var detail: MovieDetailResponse?
        var similar: [Movie]?
    }
    
    @Driving var fetching: Bool = false
    @Driving var favorited: Bool = false
    @Driving var backdrop: URL?
    @Driving var sections: Sections = .init()
}

final class MovieDetailViewModel: ViewModel<MovieDetailAction, MovieDetailMutation, MovieDetailState, MovieDetailEvent> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let movieId: Int
    let backdrop: URL
    let dataStorage: DataStorage
    
    init(imageConfiguration: ImageConfiguration, movieId: Int, backdrop: URL, dataStorage: DataStorage = DataStorage.shared) {
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
        self.movieId = movieId
        self.backdrop = backdrop
        self.dataStorage = dataStorage
        
        let state = State(backdrop: backdrop)
        
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
            return MVDVService.shared.movie.detail(id: movieId,
                                                   includeStates: dataStorage.authenticated)
                .flatMap { detail -> Observable<Reaction> in
                    let sections = State.Sections(detail: detail,
                                                  similar: detail.similar?.results)
                    let favorited = detail.account_states?.favorite ?? false
                    return .of(.mutation(.sections(sections)),
                               .mutation(.favorited(favorited)))
                }
                .catch {
                    .just(.event(.alert($0.localizedDescription)))
                }
                .startWith(Reaction.mutation(.fetching(true)))
                .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
        case .toggleFavorite:
            guard let sessionId = dataStorage.authentication?.sessionId,
                  let accountId = dataStorage.authentication?.accountId
            else {
                return .just(Reaction.event(.notAuthenticated))
            }
            
            let favorited = !state.favorited
            return MVDVService.shared.account.markFavorite(favorited,
                                                           mediaId: movieId,
                                                           sessionId: sessionId,
                                                           accountId: accountId)
            .map { _ in
                Reaction.mutation(.favorited(favorited))
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
        case .favorited(let favorited):
            state.favorited = favorited
        case .sections(let sections):
            state.sections = sections
        }
        return state
    }
}
