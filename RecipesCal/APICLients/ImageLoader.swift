//
//  ImageLoader.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//


import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private var task: URLSessionDataTask?
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() { }
    
    func getImage(_ stringUrl: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let stringUrl else {
            return
        }
        
        guard let urlRequest = request(from: stringUrl, method: .get)  else {
            completion(.failure(APIServiceError.failedToCreateRequest))
            return
        }
        
        task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(APIServiceError.failedToCreateRequest))
                return
            }
            
            let value = data as NSData
            let key = NSString(string: stringUrl)
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task?.resume()
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