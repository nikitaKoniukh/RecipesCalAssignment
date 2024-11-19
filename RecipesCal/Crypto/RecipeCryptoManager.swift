//
//  RecipeCryptoManager.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 19/11/2024.
//


import CryptoKit
import LocalAuthentication

final class RecipeCryptoManager {
    private let keychainKey = "com.example.recipeKey"
    
    private func getSymmetricKey() throws -> SymmetricKey {
        if let storedKeyData = KeychainHelper.shared.load(key: keychainKey) {
            return SymmetricKey(data: storedKeyData)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            try KeychainHelper.shared.save(key: keychainKey, data: newKey.withUnsafeBytes { Data($0) })
            return newKey
        }
    }
    
    func encrypt(recipe: Recipe) throws -> Data {
        let key = try getSymmetricKey()
        let encoder = JSONEncoder()
        let recipeData = try encoder.encode(recipe)
        let sealedBox = try AES.GCM.seal(recipeData, using: key)
        return sealedBox.combined!
    }
    
    func getSymmetricKeyWithBiometricsOrPassword(data: Data, prompt: String, fallbackPrompt: String, completion: @escaping (Result<Recipe?, Error>) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = fallbackPrompt
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: prompt) { success, authError in
                if success {
                    do {
                        let key = try self.getSymmetricKey()
                        let sealedBox = try AES.GCM.SealedBox(combined: data)
                        let decryptedData = try AES.GCM.open(sealedBox, using: key)
                        let decoder = JSONDecoder()
                        let recipe = try decoder.decode(Recipe.self, from: decryptedData)
                        completion(.success(recipe))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let authError = authError {
                    completion(.failure(authError))
                }
            }
        } else {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: prompt) { success, authError in
                if success {
                    do {
                        let key = try self.getSymmetricKey()
                        let sealedBox = try AES.GCM.SealedBox(combined: data)
                        let decryptedData = try AES.GCM.open(sealedBox, using: key)
                        let decoder = JSONDecoder()
                        let recipe = try decoder.decode(Recipe.self, from: decryptedData)
                        completion(.success(recipe))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let authError = authError {
                    completion(.failure(authError))
                }
            }
        }
    }
}