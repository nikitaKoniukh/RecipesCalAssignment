//
//  APIService.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//


import Foundation

final class APIService {
    
    static let shared = APIService()
    
    private init(){}
    
    public func execute<T: Codable>(_ stringUrl: String?, method: HttpMethod = .get, expecting type: T.Type, completion: @escaping (Result<T, RecipeError>) -> Void) {
        
        guard let request = request(from: stringUrl, method: method) else {
            completion(.failure(RecipeError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                let statusCodeString = String((response as? HTTPURLResponse)?.statusCode ?? 0)
                completion(.failure(RecipeError.badResponse(message: "Status code \(statusCodeString)")))
                return
            }
            
            guard let data = data,
                    error == nil else {
                completion(.failure(RecipeError.networkError(error: error!)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch(let error) {
                completion(.failure(RecipeError.jsonDecodingError(error: error)))
            }
        }
        
        task.resume()
    }
    
    
    private func request(from stringUrl: String?, method: HttpMethod) -> URLRequest? {
        guard let stringUrl,
        let url = URL(string: stringUrl) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 10
        return request
    }
}
