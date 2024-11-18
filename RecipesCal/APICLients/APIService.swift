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
    
    public func execute<T: Codable>(_ stringUrl: String?, method: HttpMethod = .get, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let request = request(from: stringUrl, method: method) else {
            completion(.failure(APIServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
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
