//
//  APIServiceError.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//


enum APIServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
    case badServerResponse
}


