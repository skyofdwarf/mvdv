//
//  MVDVService+API.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/15.
//

import Foundation
import RxSwift
import Moya
import AuthenticationServices

// MARK: Common APIs

extension MVDVService {
    func configuration() -> Observable<ConfigurationResponse> {
        request(ConfigurationTarget.configuration)
    }
}

// MARK: API groups

extension MVDVService {
    struct Authentication: ServiceRedirect {
        let base: MVDVService
    }
    
    struct Movie: ServiceRedirect {
        let base: MVDVService
    }
    
    var authentication: Authentication { Authentication(base: self) }
    var movie: Movie { Movie(base: self) }
}

/// Proxy protocol to short calling of request method
protocol ServiceRedirect {
    var base: MVDVService { get }
}

extension ServiceRedirect {
    func request<D: Decodable>(_ target: TargetType) -> Observable<D> {
        base.request(target)
    }
}

// MARK: Authentication APIs

extension MVDVService.Authentication {
    static let redirectScheme = "mvdv"
    static func authenticationUrl(requestToken: String) -> URL? {
        URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=\(redirectScheme)://approved")
    }
    
    enum Error: Swift.Error {
        case unknown
        case invalidAuthenticationURL
        case sessionFailed
    }
   
    func authenticate(providing: ASWebAuthenticationPresentationContextProviding?) -> Observable<NewSessionResponse> {
        requestToken()
            .flatMap { response -> Observable<NewSessionResponse> in
                let requestToken = response.request_token
                
                return askPermission(requestToken: requestToken, providing: providing)
                    .flatMap { approved -> Observable<NewSessionResponse> in
                        if approved {
                            return newSession(requestToken: requestToken)
                        } else {
                            return .error(Error.sessionFailed)
                        }
                    }
            }
    }
    
    private func requestToken() -> Observable<AuthenticationTokenResponse> {
        request(AuthenticationTarget.requestToken)
    }
    
    private func newSession(requestToken: String) -> Observable<NewSessionResponse> {
        request(AuthenticationTarget.newSession(requestToken: requestToken))
    }
    
    private func askPermission(requestToken: String, providing: ASWebAuthenticationPresentationContextProviding?) -> Observable<Bool> {
        guard let url = Self.authenticationUrl(requestToken: requestToken) else {
            return .error(Error.invalidAuthenticationURL)
        }
        
        return Single<Bool>.create { observer in
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: Self.redirectScheme) { url, error in
                guard let url else {
                    observer(.failure(error ?? Error.unknown))
                    return
                }
                
                let denied = url.query?.contains("denied") ?? false
                
                observer(.success(!denied))
            }
            
            session.presentationContextProvider = providing
            session.start()
            
            return Disposables.create {
                session.cancel()
            }
        }
        .asObservable()
    }
}

// MARK: Movie APIs

extension MVDVService.Movie {
    func genres() -> Observable<GenreResponse> {
        request(MovieTarget.genres)
    }
    
    func nowPlaying() -> Observable<NowPlayingMovieResponse> {
        request(MovieTarget.nowPlaying)
    }
    
    func popular() -> Observable<MovieResponse> {
        request(MovieTarget.popular)
    }
    
    func topRated() -> Observable<MovieResponse> {
        request(MovieTarget.topRated)
    }
    
    func upcoming() -> Observable<UpcomingMovieResponse> {
        request(MovieTarget.upcoming)
    }
    
    func trending() -> Observable<MovieResponse> {
        request(MovieTarget.trending)
    }
    
    func detail(id: Int) -> Observable<MovieDetailResponse> {
        request(MovieTarget.detail(id))
    }
    
    func similar(id: Int) -> Observable<MovieDetailResponse> {
        request(MovieTarget.similar(id))
    }
    
    func search(query: String, page: Int = 1) -> Observable<MovieResponse> {
        request(MovieTarget.search(query: query, page: page))
    }
}
