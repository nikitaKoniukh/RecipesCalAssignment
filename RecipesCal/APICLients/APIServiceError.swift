//
//  APIServiceError.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//


enum RecipeError: Error {
    case authenticationFailed
    case encryptionError
    case decryptionError
    case jsonDecodingError(error: Error)
    case networkError(error: Error)
    case badResponse(message: String)
    case failedToCreateRequest
    case generalError(message: String)
    
    var title: String {
        switch self {
        case .authenticationFailed:
            return "Authentication Failed"
        case .encryptionError:
            return "Encryption Error"
        case .decryptionError:
            return "Decryption Error"
        case .jsonDecodingError:
            return "Decoding Error"
        case .networkError:
            return "Network Error"
        case .generalError:
            return "Error"
        case .failedToCreateRequest:
            return "Network Error"
        case .badResponse:
            return "Bad Response"
        }
    }
    
    var message: String {
        switch self {
        case .authenticationFailed:
            return "Unable to authenticate. Please try again."
        case .encryptionError:
            return "An error occurred during encryption. Please check the data and try again."
        case .decryptionError:
            return "An error occurred during decryption. Please check the data and try again."
        case .jsonDecodingError(let error):
            return "Failed to decode the response. Error: \(error.localizedDescription)"
        case .networkError(let error):
            return "A network error occurred. Error: \(error.localizedDescription)"
        case .generalError(let message):
            return message
        case .failedToCreateRequest:
            return "Failed to create request."
        case .badResponse(let message):
            return message
        }
    }
}
