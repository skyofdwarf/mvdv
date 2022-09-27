//
//  MVDVService+API.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/15.
//

import Foundation
import RxSwift
import Moya

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
    func requestToken() -> Observable<AuthenticationTokenResponse> {
        request(AuthenticationTarget.authenticationToken)
    }
    
    func newSession(requestToken: String) -> Observable<NewSessionResponse> {
        request(AuthenticationTarget.newSession(requestToken: requestToken))
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
