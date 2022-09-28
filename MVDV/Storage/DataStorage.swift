//
//  DataStorage.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/29.
//

import Foundation

final class DataStorage {
    static let shared = DataStorage()
    
    var accountId: String?
    var sessionId: String?
    
    private init() {
        readAccount()
    }
    
    func saveAccount(accountId: String, sessionId: String) {
        self.accountId = accountId
        self.sessionId = sessionId
    }
    
    func readAccount() {
        accountId = nil
        sessionId = nil
    }
}
