//
//  WebServiceManager.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct WebService: WebServiceProtocol {
    
    // MARK: - WebServiceProtocol Properties
    
    static var baseUrl = "https://api.themoviedb.org/3"
   
    // MARK: - Private Properties

    private static let apiKey = "90a5acd11cdcfb676199c9476c07cbb9"
    
    enum WebServiceError: Error {
        case invalidUrl
        case invalidHttpBody
        case invalidDataResponse
        case callFailed(data: Data?, response: URLResponse?, error: Error?)
    }
    
    // MARK: - WebServiceProtocol Methods

    static func call(webServiceRequest: WebServiceRequest, completion: @escaping ((Result<Data>) -> Void)) {
        guard let request = makeRequest(webServiceRequest: webServiceRequest, completion: completion) else {
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
    
    // MARK: - Private Methods

    static private func makeUrlString(fromUrlString urlString: String) -> String {
        let apiKeyString = "api_key=\(apiKey)"
        return urlString.contains("?") ? urlString + "&\(apiKeyString)" : urlString + "?\(apiKeyString)"
    }
    
    static private func makeRequest(webServiceRequest: WebServiceRequest, completion: ((Result<Data>) -> Void)) -> URLRequest? {
        let urlString = makeUrlString(fromUrlString: baseUrl + webServiceRequest.url)
        guard let url = URL(string: urlString) else {
            return nil
        }

        let request = NSMutableURLRequest(url: url)
        #if DEBUG
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        #endif
        request.timeoutInterval = 10.0
        request.httpMethod = webServiceRequest.method.rawValue
        webServiceRequest.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        guard let params = webServiceRequest.params, webServiceRequest.method == .put || webServiceRequest.method == .post || webServiceRequest.method == .patch else {
            return request as URLRequest
        }
        
        switch webServiceRequest.paramsEncoding {
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
