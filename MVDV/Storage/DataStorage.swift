//
//  DataStorage.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/29.
//

import Foundation

struct Authentication: CustomStringConvertible {
    var sessionId: String
    var accountId: String
    var avatarHash: String?
    
    var description: String {
        "accountId: \(accountId), gravatarHash: \(String(describing: avatarHash)), sessionId: \(sessionId)"
    }
}

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
    
    private(set) var authentication: Authentication?

    var authenticated: Bool { authentication != nil }
    
    private init() {
        try? readAccount()
        print("DataStorage: \(self)")
    }
    
    func saveAccount(authentication: Authentication) throws {
        guard let data = authentication.sessionId.data(using: .utf8) else {
            throw Error.invalidData
        }

        let avatarData = authentication.avatarHash?.data(using: .utf8)
        
        // delete old accounts
        try deleteAllAccounts()
        
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: authentication.accountId,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
 kSecUseDataProtectionKeychain: true,
                 kSecAttrLabel: Self.keychainLabel,
               kSecAttrGeneric: avatarData ?? Data(),
                 kSecValueData: data
        ] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw Error.keychain(status)
        }
        
        self.authentication = authentication
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
            
            var gravatarHash: String?
            
            if let gravatarData = attrs[kSecAttrGeneric] as? Data {
                gravatarHash = String(data: gravatarData, encoding: .utf8)
            }
            
            authentication = Authentication(sessionId: sessionId,
                                            accountId: accountId,
                                            avatarHash: gravatarHash)
        default:
            throw Error.keychain(status)
        }
    }
        
    func deleteAllAccounts() throws {
        let query = [kSecClass: kSecClassGenericPassword,
                 kSecAttrLabel: Self.keychainLabel
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        
        authentication = nil
        
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
    authentication: \(String(describing: authentication))
    """
    }
}
