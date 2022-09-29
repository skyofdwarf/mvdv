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
        
        XCTAssertNil(DataStorage.shared.accountId)
        XCTAssertNil(DataStorage.shared.sessionId)
        XCTAssertNil(DataStorage.shared.gravatarHash)
    }
    
    func testSaveAccount() throws {
        let accountId = "account id"
        let sessionId = "session id"
        let gravatarHash = "gravatar hash"
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.accountId)
        XCTAssertNil(DataStorage.shared.sessionId)
        XCTAssertNil(DataStorage.shared.gravatarHash)
        
        try DataStorage.shared.saveAccount(accountId: accountId, sessionId: sessionId, gravatarHash: gravatarHash)
        
        XCTAssertEqual(DataStorage.shared.sessionId, sessionId)
        XCTAssertEqual(DataStorage.shared.accountId, accountId)
        XCTAssertEqual(DataStorage.shared.gravatarHash, gravatarHash)
    }
    
    func testManageOnlyOneAccount() throws {
        let accountId = "account id"
        let sessionId = "session id"
        let gravatarHash = "gravatar hash"
        
        let accountId2 = "account id 2"
        let sessionId2 = "session id 2"
        let gravatarHash2 = "gravatar hash 2"
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.accountId)
        XCTAssertNil(DataStorage.shared.sessionId)
        XCTAssertNil(DataStorage.shared.gravatarHash)
        
        try DataStorage.shared.saveAccount(accountId: accountId, sessionId: sessionId, gravatarHash: gravatarHash)
        
        XCTAssertEqual(DataStorage.shared.sessionId, sessionId)
        XCTAssertEqual(DataStorage.shared.accountId, accountId)
        XCTAssertEqual(DataStorage.shared.gravatarHash, gravatarHash)
        
        try DataStorage.shared.saveAccount(accountId: accountId2, sessionId: sessionId2, gravatarHash: gravatarHash2)
        
        XCTAssertEqual(DataStorage.shared.sessionId, sessionId2)
        XCTAssertEqual(DataStorage.shared.accountId, accountId2)
        XCTAssertEqual(DataStorage.shared.gravatarHash, gravatarHash2)
        
        try DataStorage.shared.readAccount()
        
        XCTAssertEqual(DataStorage.shared.sessionId, sessionId2)
        XCTAssertEqual(DataStorage.shared.accountId, accountId2)
        XCTAssertEqual(DataStorage.shared.gravatarHash, gravatarHash2)
    }
    
    func testDeleteAllAccounts() throws {
        let accountId = "account id"
        let sessionId = "session id"
        let gravatarHash = "gravatar hash"
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.accountId)
        XCTAssertNil(DataStorage.shared.sessionId)
        XCTAssertNil(DataStorage.shared.sessionId)
        
        try DataStorage.shared.saveAccount(accountId: accountId, sessionId: sessionId, gravatarHash: gravatarHash)
        
        XCTAssertEqual(DataStorage.shared.sessionId, sessionId)
        XCTAssertEqual(DataStorage.shared.accountId, accountId)
        XCTAssertEqual(DataStorage.shared.gravatarHash, gravatarHash)
        
        
        try DataStorage.shared.readAccount()
        
        XCTAssertEqual(DataStorage.shared.sessionId, sessionId)
        XCTAssertEqual(DataStorage.shared.accountId, accountId)
        XCTAssertEqual(DataStorage.shared.gravatarHash, gravatarHash)
        
        try DataStorage.shared.deleteAllAccounts()
        
        XCTAssertNil(DataStorage.shared.accountId)
        XCTAssertNil(DataStorage.shared.sessionId)
        XCTAssertNil(DataStorage.shared.gravatarHash)
        
        try DataStorage.shared.readAccount()
        
        XCTAssertNil(DataStorage.shared.accountId)
        XCTAssertNil(DataStorage.shared.sessionId)
        XCTAssertNil(DataStorage.shared.gravatarHash)
    }
}
