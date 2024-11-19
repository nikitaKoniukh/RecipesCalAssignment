//
//  KeychainHelper.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 19/11/2024.
//

import Foundation

enum KeychainError: Error {
    case unableToSave
    case unableToLoad
}

final class KeychainHelper {
    static let shared = KeychainHelper()
    
    func save(key: String, data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave
        }
    }
    
    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }
}
