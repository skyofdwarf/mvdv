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
    
    struct Account: ServiceRedirect {
        let base: MVDVService
    }
    
    var authentication: Authentication { Authentication(base: self) }
    var movie: Movie { Movie(base: self) }
    var account: Account { Account(base: self) }
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
    
    enum Error: Swift.Error, LocalizedError {
        case unknown
        case invalidAuthenticationURL
        case permissionDenied
        case cancelled
        
        var errorDescription: String? {
            switch self {
            case .unknown: return "Unknwon error"
            case .invalidAuthenticationURL: return "Invalid authentication URL"
            case .permissionDenied: return "Permission denied"
            case .cancelled: return "Cancelled"
            }
        }
    }
   
    /// Authenticates a user
    /// 1. request token
    /// 2. confirm user permission
    /// 3. create a new session id
    func authenticate(providing: ASWebAuthenticationPresentationContextProviding?) -> Observable<NewSessionResponse> {
        // 1. request token
        requestToken()
            .flatMap { response -> Observable<NewSessionResponse> in
                let requestToken = response.request_token
                
                // 2. confirm user permission
                return askPermission(requestToken: requestToken, providing: providing)
                    .flatMap { approved -> Observable<NewSessionResponse> in
                        if approved {
                            // 3. create a new session id
                            return newSession(requestToken: requestToken)
                        } else {
                            return .error(Error.permissionDenied)
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
                    if let error = error as? ASWebAuthenticationSessionError {
                        observer(.failure(error.code == ASWebAuthenticationSessionError.canceledLogin ?
                                          Error.cancelled :
                                            Error.unknown))
                    }
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
    
    func detail(id: Int, includeStates stated: Bool) -> Observable<MovieDetailResponse> {
        request(MovieTarget.detail(id, stated: stated))
    }
    
    func similar(id: Int) -> Observable<MovieDetailResponse> {
        request(MovieTarget.similar(id))
    }
    
    func search(query: String, page: Int = 1) -> Observable<MovieResponse> {
        request(MovieTarget.search(query: query, page: page))
    }
}

// MARK: Account APIs

extension MVDVService.Account {
    enum Error: Swift.Error {
        case unbound
    }
    
    func account(sessionId: String) -> Observable<AccountResponse> {
        return request(AccountTarget.account(sessionId: sessionId))
    }
    
    func markFavorite(_ favorited: Bool, mediaId: Int, sessionId: String, accountId: String) -> Observable<MarkFavoriteResponse> {
        return request(AccountTarget.markFavorite(accountId: accountId,
                                                  sessionId: sessionId,
                                                  mediaId: mediaId,
                                                  favorited: favorited))
    }
    
    func favoritesMovies(sessionId: String, accountId: String) -> Observable<MovieResponse> {
        return request(AccountTarget.favoriteMovies(accountId: accountId, sessionId: sessionId))
    }
}
