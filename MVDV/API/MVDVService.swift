//
//  MVDVService.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/19.
//

import Foundation
import Moya
import Keys
import RxSwift
import RxMoya

fileprivate let accessToken = MVDBKeys().apiAccessToken

final class MVDVService: APIService {
    static let shared = MVDVService()
    
    let dataStorage: DataStorage
    
    init(dataStorage: DataStorage = DataStorage.shared) {
#if DEBUG
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)),
            AccessTokenPlugin(tokenClosure: { _ in accessToken })
        ]
#else
        
        let plugins: [PluginType] = [
            AccessTokenPlugin(tokenClosure: { _ in accessToken })
        ]
#endif
        
        self.dataStorage = dataStorage
        
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)
        
        super.init(provider: provider)
    }
}
