//
//  APIService+MVDV.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/15.
//

import Foundation
import RxSwift

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
    
    func upcoming() -> Observable<UpcomingMovieResponse> {
        request(MovieTarget.upcoming)
    }
    
    func trending() -> Observable<TrendingMovieResponse> {
        request(MovieTarget.trending)
    }
    
    func detail(id: Int) -> Observable<MovieDetailResponse> {
        request(MovieTarget.detail(id))
    }
    
    func similar(id: Int) -> Observable<MovieDetailResponse> {
        request(MovieTarget.similar(id))
    }
}
