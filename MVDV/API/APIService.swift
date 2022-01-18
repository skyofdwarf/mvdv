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

fileprivate let accessToken = MVDBKeys().apiAccessToken

final class APIService {
    static let shared = APIService()
    
    fileprivate lazy var provider: MoyaProvider<MultiTarget> = {
#if DEBUG
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(),
            AccessTokenPlugin(tokenClosure: { _ in accessToken })
        ]
        
        return MoyaProvider<MultiTarget>(plugins: plugins)
#else
        return MoyaProvider<MultiTarget>()
#endif
    }()
    
    private init() {}
    
    // Raw request method
    func request(_ target: MVDBTarget, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(MultiTarget(target)) { completion($0) }
    }

    // Mapping requests
    func request<D: Decodable>(_ target: MVDBTarget, success: @escaping (D) -> (), failure: @escaping (Error) -> ()) {
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
    func request<D: Decodable>(_ target: MVDBTarget) -> Single<D> {
        provider.rx
            .request(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .map(D.self)
    }
}

// MARK: Target requests

extension APIService {
    func configuration() -> Single<ConfigurationModel> {
        request(ConfigurationTarget.configuration)
    }
}
