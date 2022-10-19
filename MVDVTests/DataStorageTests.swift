//
//  DataStorageTests.swift
//  MVDVTests
//
//  Created by YEONGJUNG KIM on 2022/09/29.
//

import XCTest
@testable import MVDV

final class DataStorageTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try DataStorage.shared.deleteAllAccounts()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        try DataStorage.shared.deleteAllAccounts()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
       
    func testReadEmptyAccount() throws {
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.authentication)
    }
    
    func testSaveAccount() throws {
        let authentication = Authentication(sessionId: "session id",
                                            accountId: "account id",
                                            gravatarHash: "gravatar hash")
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.authentication)
        
        try DataStorage.shared.saveAccount(authentication: authentication)
        
        XCTAssertEqual(DataStorage.shared.authentication, authentication)
    }
    
    func testManageOnlyOneAccount() throws {
        let authentication = Authentication(sessionId: "session id",
                                            accountId: "account id",
                                            gravatarHash: "gravatar hash")
        
        let authentication2 = Authentication(sessionId: "session id 2",
                                             accountId: "account id 2",
                                             gravatarHash: "gravatar hash 2")
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.authentication)
        
        try DataStorage.shared.saveAccount(authentication: authentication)
        
        XCTAssertEqual(DataStorage.shared.authentication, authentication)
        
        try DataStorage.shared.saveAccount(authentication: authentication2)
        
        XCTAssertEqual(DataStorage.shared.authentication, authentication2)
        
        try DataStorage.shared.readAccount()
        
        XCTAssertEqual(DataStorage.shared.authentication, authentication2)
    }
    
    func testDeleteAllAccounts() throws {
        let authentication = Authentication(sessionId: "session id",
                                            accountId: "account id",
                                            gravatarHash: "gravatar hash")
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.authentication)
                
        try DataStorage.shared.saveAccount(authentication: authentication)
        
        XCTAssertEqual(DataStorage.shared.authentication, authentication)
        
        try DataStorage.shared.readAccount()
        
        XCTAssertEqual(DataStorage.shared.authentication, authentication)
        
        try DataStorage.shared.deleteAllAccounts()
        
        XCTAssertNil(DataStorage.shared.authentication)
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.authentication)
    }
}
