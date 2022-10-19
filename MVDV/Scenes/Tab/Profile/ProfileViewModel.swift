//
//  ProfileViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/28.
//

import Foundation
import RDXVM
import RxSwift
import AuthenticationServices

enum ProfileAction {
    case authenticate(ASWebAuthenticationPresentationContextProviding)
    case unbind
    case fetch
    case showFavorites
}

enum ProfileEvent {
    case alert(String)
}

enum ProfileMutation {
    case fetching(Bool)
    case authentication(Authentication?)
    case favorites([Movie])
}

struct ProfileState {
    struct Sections {
        var version: String?
        var profile: Authentication?
        var favorites: [Movie] = []
    }
    
    @Driving var fetching = false
    @Driving var authenticated = false
    @Driving var sections = Sections()
}

final class ProfileViewModel: ViewModel<ProfileAction, ProfileMutation, ProfileEvent, ProfileState> {
    private(set) var db = DisposeBag()
    
    let imageConfiguration: ImageConfiguration
    let coordinator: ProfileCoordinator
    let dataStorage: DataStorage
    
    init(imageConfiguration: ImageConfiguration, coordinator: ProfileCoordinator, dataStorage: DataStorage = DataStorage.shared) {
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
        self.dataStorage = dataStorage
        
        var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            version.append("(\(build))")
        }
        
        let state = State(fetching: false,
                          authenticated: dataStorage.authenticated,
                          sections: .init(version: version,
                                          profile: dataStorage.authentication,
                                          favorites: []))
        
        super.init(state: state,
                   actionMiddlewares: actionMiddlewares,
                   /*mutationMiddlewares: mutationMiddlewares,*/
                   eventMiddlewares: eventMiddlewares/*,
                   stateMiddlewares: stateMiddlewares*/)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .authenticate(let providing):
            return authenticate(providing)
            
        case .unbind:
            return unbind()
            
        case .fetch:
            return fetch()
            
        case .showFavorites:
            return showFavorites()
        }
    }
    
    override func reduce(mutation: Mutation, state: State) -> State {
        var state = state
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .authentication(let authentication):
            state.sections.profile = authentication
            state.authenticated = authentication != nil
            state.sections.favorites = []
        case .favorites(let movies):
            state.sections.favorites = movies
        }
        return state
    }
    
    override func transform(action: Observable<Action>) -> Observable<Action> {
        // relays events of AppModel to action
        let authenticated = AppModel.shared.event
            .asObservable()
            .flatMap { event -> Observable<Action> in
                switch event {
                case .authenticated:
                    return .just(Action.fetch)
                default:
                    return .empty()
                }
            }
            .observe(on: MainScheduler.asyncInstance) ///< Avoid conflicting with 'fetching' state of AppModel
        
        return .merge(action,
                      authenticated)
    }
    
    override func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        // relays some state of AppModel to mutation
        
        let fetching = AppModel.shared.state.$fetching
            .distinctUntilChanged()
            .map { Mutation.fetching($0) }
            .asObservable()
        
        let authentication = AppModel.shared.state.$authentication
            .map { Mutation.authentication($0) }
            .asObservable()
        
        return .merge(mutation,
                      fetching,
                      authentication)
    }
        
    override func transform(error: Observable<Error>) -> Observable<Error> {
        .merge(error, AppModel.shared.error.asObservable())
    }
}

extension ProfileViewModel {
    func authenticate(_ providing: ASWebAuthenticationPresentationContextProviding) -> Observable<Reaction> {
        AppModel.shared.send(action: .authenticate(providing))
        return .empty()
    }
    
    func unbind() -> Observable<Reaction> {
        AppModel.shared.send(action: .unbind)
        return .empty()
    }
    
    func fetch() -> Observable<Reaction> {
        guard let sessionId = dataStorage.authentication?.sessionId,
              let accountId = dataStorage.authentication?.accountId
        else {
            return .just(.event(.alert(Strings.Common.notAuthenticatedYet)))
        }
        
        return MVDVService.shared.account.favoritesMovies(sessionId: sessionId, accountId: accountId)
            .map {
                Reaction.mutation(.favorites($0.results))
            }
            .catch { .just(.event(.alert($0.localizedDescription))) }
            .startWith(Reaction.mutation(.fetching(true)))
            .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
    }
    
    func showFavorites() -> Observable<Reaction> {
        guard state.authenticated else {
            return .just(.event(.alert(Strings.Common.notAuthenticatedYet)))
            
        }
        coordinator.showFavorites(imageConfiguration: imageConfiguration)
        return .empty()
    }
}
