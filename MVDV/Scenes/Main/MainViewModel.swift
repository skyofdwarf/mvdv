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

extension AppEvent {
    var coordinate: MainAction.Coordinate? {
        switch self {
        case .ready(let ic): return MainAction.Coordinate.tabs(ic)
        default: return nil
        }
    }
}

enum MainAction {
    case ready
    case coordinate(Coordinate)
    
    enum Coordinate {
        case tabs(ImageConfiguration)
    }
}

enum MainEvent {
    case alert(String)
}

enum MainMutation {
    case fetching(Bool)
    case imageConfiguration(ImageConfiguration?)
}

struct MainState {
    @Drived var fetching: Bool = false
    @Drived var imageConfiguration: ImageConfiguration?
}

final class MainViewModel: ViewModel<MainAction, MainMutation, MainEvent, MainState> {
    private(set) var db = DisposeBag()
    
    let dataStorage: DataStorage
    let coordinator: MainCoordinator
    
    init(dataStorage: DataStorage = DataStorage.shared, coordinator: MainCoordinator) {
        self.dataStorage = dataStorage
        self.coordinator = coordinator
        
        super.init(state: State())
    }
    
    // MARK: - Interfaces
    
    override func react(action: Action, state: State) -> Observable<Reaction> {
        switch action {
        case .ready:
            AppModel.shared.send(action: .ready)
            
        case .coordinate(let coord):
            return coordinate(coord)
        }
        
        return .empty()
    }
    
    override func reduce(mutation: Mutation, state: inout State) {
        switch mutation {
        case .fetching(let fetching):
            state.fetching = fetching
        case .imageConfiguration(let imageConfiguration):
            state.imageConfiguration = imageConfiguration
        }
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
    
    override func transform(action: Observable<Action>) -> Observable<Action> {
        let coordinate = AppModel.shared.event
            .compactMap { $0.coordinate }
            .map { Action.coordinate($0) }
            .asObservable()
        
        return .merge(action, coordinate)
    }
    
    func coordinate(_ coordinate: MainAction.Coordinate) -> Observable<Reaction> {
        switch coordinate {
        case .tabs(let ic):
            coordinator.showTabs(imageConfiguration: ic)
        }
        
        return .empty()
    }
}
