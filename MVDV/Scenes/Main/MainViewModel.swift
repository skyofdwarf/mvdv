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

enum MainAction: ViewModelAction {
}

enum MainEvent: ViewModelEvent {
    case alert(String)
}

enum MainMutation: ViewModelMutation {
    case fetching(Bool)
    case imageConfiguration(ImageConfiguration?)
}

struct MainState: ViewModelState {
    @Driving var fetching: Bool = false
    @Driving var imageConfiguration: ImageConfiguration?
}

final class MainViewModel: ViewModel<MainAction, MainMutation, MainState, MainEvent> {
    private(set) var db = DisposeBag()
    
    let actionRelay = PublishRelay<AppModel.Action>()
    
    init(state initialState: State = State()) {
        super.init(state: initialState)
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        .empty()
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
}
