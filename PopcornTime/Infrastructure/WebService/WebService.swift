//
//  WebServiceManager.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct WebService {
    
    private static let baseUrl = "https://api.themoviedb.org/3"
    private static let apiKey = "90a5acd11cdcfb676199c9476c07cbb9"
    
    enum WebServiceError: Error {
        case invalidUrl
        case invalidHttpBody
        case invalidDataResponse
        case callFailed(data: Data?, response: URLResponse?, error: Error?)
    }
    
    static func call(configuration: WebServiceConfiguration, completion: @escaping ((Result<Data>) -> Void)) {
        guard let request = makeRequest(configuration: configuration, completion: completion) else {
            completion(Result.failure(error: WebServiceError.invalidUrl))
            return
        }
    
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(Result.failure(error: WebServiceError.callFailed(data: data, response: response, error: error)))
                }
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    DispatchQueue.main.async {
                        completion(Result.success(value: data))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(Result.failure(error: WebServiceError.invalidDataResponse))
                    }
                }
            default:
                DispatchQueue.main.async {
                    completion(Result.failure(error: WebServiceError.callFailed(data: data, response: response, error: error)))
                }
            }
        })
        
        dataTask.resume()
    }
    
    static private func makeUrlString(fromUrlString urlString: String) -> String {
        let apiKeyString = "api_key=\(apiKey)"
        return urlString.contains("?") ? urlString + "&\(apiKeyString)" : urlString + "?\(apiKeyString)"
    }
    
    static private func makeRequest(configuration: WebServiceConfiguration, completion: ((Result<Data>) -> Void)) -> URLRequest? {
        let urlString = makeUrlString(fromUrlString: baseUrl + configuration.url)
        guard let url = URL(string: urlString) else {
            return nil
        }

        let request = NSMutableURLRequest(url: url)
        #if DEBUG
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        #endif
        request.timeoutInterval = 10.0
        request.httpMethod = configuration.method.rawValue
        configuration.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        guard let params = configuration.params, configuration.method == .put || configuration.method == .post || configuration.method == .patch else {
            return request as URLRequest
        }
        
        switch configuration.paramsEncoding {
        case .urlEncoded:
            let body = makeUrlEncode(params: params)
            request.httpBody = body.data(using: String.Encoding.utf8)
        case .json:
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        return request as URLRequest
    }
    
    static private func makeUrlEncode(params: [String: Any]) -> String {
        return params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    }

}
