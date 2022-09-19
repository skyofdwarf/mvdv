//
//  APIService.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation
import Moya
import Keys
import RxSwift
import RxMoya

class APIService {
    let provider: MoyaProvider<MultiTarget>
    
    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.provider = provider
    }
    
    convenience init() {
#if DEBUG
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)),
        ]
#else
        let plugins: [PluginType] = []
#endif
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)
        
        self.init(provider: provider)
    }
    
    // Raw request method
    func request(_ target: TargetType, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(MultiTarget(target)) { completion($0) }
    }

    // Mapping requests
    func request<D: Decodable>(_ target: TargetType, success: @escaping (D) -> (), failure: @escaping (Error) -> ()) {
        request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let successfulResponse = try response.filterSuccessfulStatusCodes()
                    success(try successfulResponse.map(D.self))
                } catch {
                    failure(error)
                }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    // Raw request.rx method
    func request<D: Decodable>(_ target: TargetType) -> Observable<D> {
        provider.rx
            .request(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .map(D.self)
            .asObservable()
    }
}
