//
//  WebServiceManager.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

class WebServiceManager: NSObject {
    
    private static let baseUrl = "https://api.themoviedb.org/3"
    private static let apiKey = "90a5acd11cdcfb676199c9476c07cbb9"
    
    enum WebServiceError: Error {
        case invalidUrl
        case invalidHttpBody
        case invalidDataResponse
        case callFailed(data: Data, response: URLResponse?, error: Error?)
    }
    
    static func call(webService: WebService, completion: @escaping ((Result<Data>) -> Void)) {
        guard let request = makeRequest(webService: webService, completion: completion) else {
            return
        }
    
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                completion(Result.failure(error: WebServiceError.invalidDataResponse))
                return
            }
            
            if error == nil {
                completion(Result.success(value: data))
            } else {
                completion(Result.failure(error: WebServiceError.callFailed(data: data, response: response, error: error)))
            }
        })
        
        dataTask.resume()
    }
    
    static private func makeUrlString(fromUrlString urlString: String) -> String {
        let apiKeyString = "api_key=\(apiKey)"
        return urlString.contains("?") ? urlString + "&\(apiKeyString)" : urlString + "?\(apiKeyString)"
    }
    
    static private func makeRequest(webService: WebService, completion: ((Result<Data>) -> Void)) -> URLRequest? {
        let urlString = makeUrlString(fromUrlString: baseUrl + webService.url)
        guard let url = URL(string: urlString) else {
            completion(Result.failure(error: WebServiceError.invalidUrl))
            return nil
        }

        let request = NSMutableURLRequest(url: url)
        #if DEBUG
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        #endif
        request.timeoutInterval = 10.0
        request.httpMethod = webService.method.rawValue
        webService.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        guard let params = webService.params, webService.method == .put || webService.method == .post || webService.method == .patch else {
            return request as URLRequest
        }
        
        switch webService.paramsEncoding {
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
