//
//  DataStorage.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/29.
//

import Foundation

/// Simple data storage
///
/// Save and load a pair of account and session on the keychain.
/// It manages only one account, so saving a new account will remove the old one already in the keychain.
final class DataStorage {
    enum Error: Swift.Error {
        case invalidData
        case keychain(OSStatus)
    }
    static let shared = DataStorage()
    
    private static let keychainLabel = "mvdv.account"
    
    var accountId: String?
    var sessionId: String?
    var gravatarHash: String?
    
    var authenticated: Bool { accountId != nil && sessionId != nil }
    
    private init() {
        try? readAccount()
        print("DataStorage: \(self)")
    }
    
    func saveAccount(accountId: String, sessionId: String, gravatarHash: String? = nil) throws {
        guard let data = sessionId.data(using: .utf8) else {
            throw Error.invalidData
        }

        let gravatarData = gravatarHash?.data(using: .utf8)
        
        // delete old accounts
        try deleteAllAccounts()
        
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: accountId,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
 kSecUseDataProtectionKeychain: true,
                 kSecAttrLabel: Self.keychainLabel,
               kSecAttrGeneric: gravatarData ?? Data(),
                 kSecValueData: data
        ] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw Error.keychain(status)
        }
        
        self.accountId = accountId
        self.sessionId = sessionId
        self.gravatarHash = gravatarHash
    }
    
    func readAccount() throws {
        let query = [kSecClass: kSecClassGenericPassword,
                 kSecAttrLabel: Self.keychainLabel,
                kSecMatchLimit: kSecMatchLimitOne,
          kSecReturnAttributes: true,
 kSecUseDataProtectionKeychain: true,
                kSecReturnData: true
        ] as [String: Any]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        switch status {
        case errSecItemNotFound:
            return
        case errSecSuccess:
            guard
                let attrs = item as? [CFString: Any],
                let sessionIdData = attrs[kSecValueData] as? Data,
                let sessionId = String(data: sessionIdData, encoding: .utf8),
                let accountId = attrs[kSecAttrAccount] as? String
            else {
                throw Error.invalidData
            }
            
            if let gravatarData = attrs[kSecAttrGeneric] as? Data {
                self.gravatarHash = String(data: gravatarData, encoding: .utf8)
            }
            
            self.accountId = accountId
            self.sessionId = sessionId
        default:
            throw Error.keychain(status)
        }
    }
        
    func deleteAllAccounts() throws {
        let query = [kSecClass: kSecClassGenericPassword,
                 kSecAttrLabel: Self.keychainLabel
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        
        self.sessionId = nil
        self.accountId = nil
        self.gravatarHash = nil
        
        switch status {
        case errSecSuccess, errSecItemNotFound:
            break;
        default:
            throw Error.keychain(status)
        }
    }
}

extension DataStorage: CustomStringConvertible {
    var description: String {
        """
    accountId: \(String(describing: accountId))
    sessionId: \(String(describing: sessionId))
    gravatarHash: \(String(describing: gravatarHash))
    """
    }
}
