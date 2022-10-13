//
//  AppModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/12.
//

import Foundation
import AuthenticationServices
import RDXVM
import RxSwift

enum AppAction: ViewModelAction {
    case ready
    case authenticate(ASWebAuthenticationPresentationContextProviding)
    case unauthenticate
    case favorited(Bool, Int)
}

enum AppEvent: ViewModelEvent, CustomStringConvertible {
    case alert(String)
    case authenticated(Authentication)
    case unauthenticated
    case favorited(Bool, Int)
    
    var description: String {
        switch self {
        case .alert(let msg): return msg
        case .authenticated: return "Authenticated"
        case .unauthenticated: return "Unauthenticated"
        case .favorited(let favorited, _): return favorited ? "Favorited": "Unfavorited"
        }
    }
}

enum AppMutation: ViewModelMutation {
    case authentication(Authentication?)
    case fetching(Bool)
    case imageConfiguration(ImageConfiguration?)
}

struct AppState: ViewModelState {
    @Driving var fetching: Bool = false
    @Driving var imageConfiguration: ImageConfiguration?
    @Driving var authentication: Authentication?
    @Driving var authenticated: Bool = false
}

final class AppModel: ViewModel<AppAction, AppMutation, AppState, AppEvent> {
    static let shared = AppModel()
    
    private(set) var db = DisposeBag()
    
    let dataStorage: DataStorage
    
    private init(dataStorage: DataStorage = DataStorage.shared) {
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
        
        let state = State(fetching: false,
                          imageConfiguration: nil,
                          authentication: dataStorage.authentication,
                          authenticated: dataStorage.authenticated)
        
        self.dataStorage = dataStorage

        super.init(state: state,
                   actionMiddlewares: actionMiddlewares,
                   eventMiddlewares: eventMiddlewares)
        
        // ready
        send(action: .ready)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .ready:
            return ready()
            
        case .unauthenticate:
            return unauthenticate()
            
        case .authenticate(let providing):
            return authenticate(dataStorage: dataStorage, providing: providing)
            
        case .favorited(let favorited, let mediaId):
            return .just(.event(.favorited(favorited, mediaId)))
        }
    }
    
    override func reduce(mutation: Mutation, state: State) -> State {
        var state = state
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .imageConfiguration(let imageConfiguration):
            state.imageConfiguration = imageConfiguration
        case .authentication(let authentication):
            state.authentication = authentication
            state.authenticated = authentication != nil
        }
        return state
    }
    
    override func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let error = error.map { _ in Mutation.fetching(false) }.asObservable()

        return .merge(mutation, error)
    }
}

private extension AppModel {
    func ready()  -> Observable<Reaction> {
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
    
    func unauthenticate() -> Observable<Reaction> {
        do {
            try dataStorage.deleteAllAccounts()
            return .of(.mutation(.authentication(nil)),
                       .event(.unauthenticated))
        } catch {
            return .error(error)
        }
    }
    
    func authenticate(dataStorage: DataStorage, providing: ASWebAuthenticationPresentationContextProviding) -> Observable<Reaction> {
        guard state.authentication == nil else {
            return .just(.event(.alert("Authenticated already")))
        }
        
        return MVDVService.shared.authentication.authenticate(providing: providing)
            .flatMap { newSessionResponse in
                // get account detail
                let sessionId: String = newSessionResponse.session_id
                return MVDVService.shared.account.account(sessionId: sessionId)
                    .map { Authentication(sessionId: sessionId,
                                          accountId: $0.username,
                                          avatarHash: $0.avatar?.gravatar?.hash) }
                    .do(onNext: {
                        // save account and session data
                        try dataStorage.saveAccount(authentication: $0)
                    })
            }
            .flatMap {
                Observable<Reaction>.of(.mutation(.authentication($0)),
                                        .event(.authenticated($0)))
            }
            .startWith(Reaction.mutation(.fetching(true)))
            .concat(Observable<Reaction>.just(.mutation(.fetching(false))))
    }
}
