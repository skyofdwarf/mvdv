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
        let configuration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: configuration),
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
    func request<D: Decodable>(_ target: MVDBTarget) -> Observable<D> {
        provider.rx
            .request(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .map(D.self)
            .asObservable()
    }
}

// MARK: Target requests

extension APIService {
    func configuration() -> Observable<ConfigurationResponse> {
        request(ConfigurationTarget.configuration)
    }

    func genres() -> Observable<GenreResponse> {
        request(MovieTarget.genres)
    }
    
    func nowPlaying() -> Observable<NowPlayingMovieResponse> {
        request(MovieTarget.nowPlaying)
    }
    
    func popular() -> Observable<PopularMovieResponse> {
        request(MovieTarget.popular)
    }
    
    func topRated() -> Observable<TopRatedMovieResponse> {
        request(MovieTarget.topRated)
    }
    
    func upcomming() -> Observable<UpcomingMovieResponse> {
        request(MovieTarget.upcomming)
    }
    
    func trending() -> Observable<TrendingMovieResponse> {
        request(MovieTarget.trending)
    }
    
    func detail(id: Int) -> Observable<MovieDetailResponse> {
        request(MovieTarget.detail(id))
    }
}
