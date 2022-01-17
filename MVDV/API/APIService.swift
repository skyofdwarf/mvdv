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
    
    private lazy var provider: MoyaProvider<MovieTarget> = {
#if DEBUG
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(),
            AccessTokenPlugin(tokenClosure: { _ in accessToken })
        ]
        
        return MoyaProvider<MovieTarget>(plugins: plugins)
#else
        return MoyaProvider<MovieTarget>()
#endif
    }()
    
    func request(_ target: MovieTarget, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(target) { completion($0) }
    }
    
    func request<T: Decodable>(_ target: MovieTarget, success: @escaping (T) -> (), failure: @escaping (Error) -> ()) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    success(try response.map(T.self))
                } catch {
                    failure(error)
                }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func request<T: Decodable>(_ target: MovieTarget) -> Single<T> {
        provider.rx.request(target).map(T.self)
    }
}
