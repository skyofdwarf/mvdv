//
//  LastestMovieResponseTests.swift
//  MVDVTests
//
//  Created by YEONGJUNG KIM on 2022/01/19.
//

import XCTest
@testable import MVDV

class LastestMovieResponseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResponseParsing_error() throws {
        let data = ErrorResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(ErrorResponse.self, from: data!))
    }
    
    func testResponseParsing_genre() throws {
        let data = GenreResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(GenreResponse.self, from: data!))
    }
    
    func testResponseParsing_configuration() throws {
        let data = ConfigurationResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(ConfigurationResponse.self, from: data!))
    }
    
    func testResponseParsing_lastestMovie() throws {
        let data = LastestMovieResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(LastestMovieResponse.self, from: data!))
    }
    
    func testResponseParsing_nowPlayingMovie() throws {
        let data = NowPlayingMovieResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(NowPlayingMovieResponse.self, from: data!))
    }
    
    func testResponseParsing_popularMovie() throws {
        let data = PopularMovieResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(PopularMovieResponse.self, from: data!))
    }
    
    func testResponseParsing_topRated() throws {
        let data = TopRatedMovieResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(TopRatedMovieResponse.self, from: data!))
    }
    
    func testResponseParsing_upcomingMovie() throws {
        let data = UpcomingMovieResponse.json.data(using: .utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(UpcomingMovieResponse.self, from: data!))
    }
}

