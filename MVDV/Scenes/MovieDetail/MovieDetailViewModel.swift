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
    case showDetail(Movie)
}

enum MovieDetailEvent: CustomStringConvertible {
    case alert(String)
    case notAuthenticated
    
    var description: String {
        switch self {
        case .alert(let msg): return msg
        case .notAuthenticated: return Strings.Common.notAuthenticatedYet
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
    
    @Drived var fetching: Bool = false
    @Drived var favorited: Bool = false
    @Drived var backdrop: URL?
    @Drived var sections: Sections = .init()
}

final class MovieDetailViewModel: ViewModel<MovieDetailAction, MovieDetailMutation, MovieDetailEvent, MovieDetailState> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let movieId: Int
    let coordinator: MovieDetailCoordinator
    let dataStorage: DataStorage
    
    init(movie: Movie, imageConfiguration: ImageConfiguration, coordinator: MovieDetailCoordinator, dataStorage: DataStorage = DataStorage.shared) {
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
        self.movieId = movie.id
        self.coordinator = coordinator
        self.dataStorage = dataStorage
        
        var state = State()
        
        if let size = imageConfiguration.backdrop_sizes.last,
           let baseUrl = URL(string: imageConfiguration.secure_base_url),
           let posterPath = movie.backdrop_path
        {
            state.backdrop = baseUrl
                .appendingPathComponent(size)
                .appendingPathComponent(posterPath)
        }
        
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
            
        case .showDetail(let movie):
            coordinator.showDetail(movie: movie, imageConfiguration: imageConfiguration)
            return .empty()
        }
    }
    
    override func reduce(mutation: Mutation, state: inout State) {
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .favorited(let favorited):
            state.favorited = favorited
        case .sections(let sections):
            state.sections = sections
        }
    }
}
