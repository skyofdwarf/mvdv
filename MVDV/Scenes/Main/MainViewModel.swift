//
//  MainViewModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/15.
//

import Foundation
import RDXVM
import RxSwift
import RxRelay

enum MainAction {
    case ready
}

enum MainEvent {
    case alert(String)
    case ready(ImageConfiguration)
    
    init?(from appEvent: AppEvent) {
        guard case .ready(let imageConfiguration) = appEvent else { return nil }
        self = .ready(imageConfiguration)
    }
}

enum MainMutation {
    case fetching(Bool)
    case imageConfiguration(ImageConfiguration?)
}

struct MainState {
    @Driving var fetching: Bool = false
    @Driving var imageConfiguration: ImageConfiguration?
}

final class MainViewModel: ViewModel<MainAction, MainMutation, MainState, MainEvent> {
    private(set) var db = DisposeBag()
    
    let dataStorage: DataStorage
    
    init(dataStorage: DataStorage = DataStorage.shared, state initialState: State = State()) {
        self.dataStorage = dataStorage
        
        super.init(state: initialState)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .ready:
            AppModel.shared.send(action: .ready)
        }
        
        return .empty()
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
    
    override func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        // relays some state of AppModel
        
        let imageConfiguration = AppModel.shared.state.$imageConfiguration
            .map { Mutation.imageConfiguration($0) }
            .asObservable()
        
        let fetching = AppModel.shared.state.$fetching
            .map { Mutation.fetching($0) }
            .asObservable()
        
        return .merge(mutation,
                      imageConfiguration,
                      fetching)
    }
    
    override func transform(event: Observable<Event>) -> Observable<Event> {
        let ready = AppModel.shared.event
            .compactMap { MainEvent(from: $0) }
            .asObservable()
        
        return .merge(event, ready)
    }
}
