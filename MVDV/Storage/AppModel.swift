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

enum AppAction {
    case ready
    case authenticate(ASWebAuthenticationPresentationContextProviding)
    case unbind
    case favorited(Bool, Int)
}

enum AppEvent: CustomStringConvertible {
    case ready(ImageConfiguration)
    case alert(String)
    case authenticated(Authentication)
    case unauthenticated
    case favorited(Bool, Int)
    
    var description: String {
        switch self {
        case .ready: return "Ready"
        case .alert(let msg): return msg
        case .authenticated: return Strings.Common.authenticated
        case .unauthenticated: return Strings.Common.unauthenticated
        case .favorited(let favorited, _): return favorited ?
            Strings.Common.favorited:
            Strings.Common.unfavorited
        }
    }
}

enum AppMutation {
    case authentication(Authentication?)
    case fetching(Bool)
    case imageConfiguration(ImageConfiguration?)
}

struct AppState {
    @Drived var fetching: Bool = false
    @Drived var imageConfiguration: ImageConfiguration?
    @Drived var authentication: Authentication?
    @Drived var authenticated: Bool = false
}

final class AppModel: ViewModel<AppAction, AppMutation, AppEvent, AppState> {
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
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .ready:
            return ready(dataStorage: dataStorage)
            
        case .unbind:
            return unbind()
            
        case .authenticate(let providing):
            return authenticate(dataStorage: dataStorage, providing: providing)
            
        case .favorited(let favorited, let mediaId):
            return .just(.event(.favorited(favorited, mediaId)))
        }
    }
    
    override func reduce(mutation: Mutation, state: inout State) {
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .imageConfiguration(let imageConfiguration):
            state.imageConfiguration = imageConfiguration
        case .authentication(let authentication):
            state.authentication = authentication
            state.authenticated = authentication != nil
        }
    }
    
    override func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let error = error.map { _ in Mutation.fetching(false) }.asObservable()

        return .merge(mutation, error)
    }
}

private extension AppModel {
    func ready(dataStorage: DataStorage)  -> Observable<Reaction> {
        return dataStorage.fetchImageConfiguration()
            .flatMap {
                Observable<Reaction>.of(.mutation(.imageConfiguration($0)),
                                        .event(.ready($0)))
            }
            .catch { _ in
                .just(.event(.alert(Strings.Common.noConfigurations)))
            }
            .startWith(Reaction.mutation(.fetching(true)))
            .concat(Observable<Reaction>.of(.mutation(.fetching(false))))
                                            
    }
    
    func unbind() -> Observable<Reaction> {
        do {
            try dataStorage.deleteAllAccounts()
            return .of(.mutation(.authentication(nil)),
                       .event(.unauthenticated))
        } catch {
            return .error(error)
        }
    }
    
    func authenticate(dataStorage: DataStorage, providing: ASWebAuthenticationPresentationContextProviding) -> Observable<Reaction> {
        guard $state.authentication == nil else {
            return .just(.event(.alert(Strings.Common.authenticatedAlready)))
        }
        
        return MVDVService.shared.authentication.authenticate(providing: providing)
            .flatMap { newSessionResponse in
                // get account detail
                let sessionId: String = newSessionResponse.session_id
                return MVDVService.shared.account.account(sessionId: sessionId)
                    .map { Authentication(sessionId: sessionId,
                                          accountId: $0.username,
                                          gravatarHash: $0.avatar?.gravatar?.hash) }
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
