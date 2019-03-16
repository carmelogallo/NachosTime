//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

class URLSessionWebService {

    // MARK: - Private Properties

    private enum WebServiceError: Error {
        case invalidUrl
        case invalidBody
        case invalidHttpUrlResponse(data: Data?, response: URLResponse?, error: Error?)
        case invalidDataResponse(data: Data?, response: URLResponse?, error: Error?)
        case invalidContext
        case parser(Error)
        case underlying(data: Data?, response: URLResponse?, error: Error?)
    }

    private let session = URLSession(configuration: .default, delegate: URLSessionDelegateWebService(), delegateQueue: .main)

}

// MARK: - WebServiceProtocol

extension URLSessionWebService: WebServiceProtocol {

    func send<T>(request: WebServiceRequest, parser: @escaping Parser<T>, completion: ((Result<T>) -> Void)?) {
        switch makeURLRequest(from: request) {
        case .success(let urlRequest):
            send(urlRequest: urlRequest, parser: parser, completion: completion)
        case .failure(let error):
            completion?(Result.failure(error: error))
        }
    }

    func send<T>(request: WebServiceRequest, medias: [WebServiceMedia], boundary: String, parser: @escaping Parser<T>, completion: ((Result<T>) -> Void)?) {
        switch makeMultipartURLRequest(from: request, medias: medias, boundary: boundary) {
        case .success(let urlRequest):
            send(urlRequest: urlRequest, parser: parser, completion: completion)
        case .failure(let error):
            completion?(Result.failure(error: error))
        }
    }

}

// MARK: - Private Methods

private extension URLSessionWebService {

    func makeURLRequest(from request: WebServiceRequest) -> Result<URLRequest> {
        // urlComponents
        guard var urlComponents = URLComponents(string: request.path.url) else {
            return .failure(error: WebServiceError.invalidUrl)
        }
        urlComponents.queryItems = request.path.query?
                .compactMap { $0 }
                .map { URLQueryItem(name: $0.key, value: $0.value) }

        // url
        guard let url = urlComponents.url else {
            return .failure(error: WebServiceError.invalidUrl)
        }

        // urlRequest
        var urlRequest = URLRequest(url: url)
        // cachePolicy
        #if DEBUG
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        #endif
        // timeoutInterval
        urlRequest.timeoutInterval = 60.0
        // httpMethod
        urlRequest.httpMethod = request.method.rawValue
        // httpHeaders
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        // httpBody
        if let body = request.body {
            switch body.encoding {
            case .json:
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body.data, options: [])
            case .urlEncoded:
                urlRequest.httpBody = body.data
                        .map { "\($0.key)=\($0.value)" }
                        .joined(separator: "&")
                        .data(using: String.Encoding.utf8)
            }

            // means that something when wrong while making httpBody
            if urlRequest.httpBody == nil {
                return .failure(error: WebServiceError.invalidBody)
            }
        }

        return .success(value: urlRequest)
    }

    func makeMultipartURLRequest(from request: WebServiceRequest, medias: [WebServiceMedia]?, boundary: String) -> Result<URLRequest> {
        // urlComponents
        guard var urlComponents = URLComponents(string: request.path.url) else {
            return .failure(error: WebServiceError.invalidUrl)
        }
        urlComponents.queryItems = request.path.query?
                .compactMap { $0 }
                .map { URLQueryItem(name: $0.key, value: $0.value) }

        // url
        guard let url = urlComponents.url else {
            return .failure(error: WebServiceError.invalidUrl)
        }

        // urlRequest
        var urlRequest = URLRequest(url: url)
        // httpMethod
        urlRequest.httpMethod = request.method.rawValue
        // httpHeaders
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        // httpBody
        urlRequest.httpBody = makeMultipartBody(params: request.body?.data, medias: medias, boundary: boundary)

        return .success(value: urlRequest)
    }

    func makeMultipartBody(params: [String : Any]?, medias: [WebServiceMedia]?, boundary: String) -> Data {

        func append(_ string: String, to data: inout Data) {
            guard let dataToAppend = string.data(using: .utf8) else { return }
            data.append(dataToAppend)
        }

        let lineBreak = "\r\n"
        var body = Data()

        params?.compactMap { $0 }
               .forEach { param in
                   let valueString = String(describing: param.value)
                   append("--\(boundary + lineBreak)", to: &body)
                   append("Content-Disposition: form-data; name=\"\(param.key)\"\(lineBreak + lineBreak)", to: &body)
                   append("\(valueString + lineBreak)", to: &body)
               }

        medias?.compactMap { $0 }
               .forEach { media in
                   append("--\(boundary + lineBreak)", to: &body)
                   append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)", to: &body)
                   append("Content-Type: \(media.mimeType + lineBreak + lineBreak)", to: &body)
                   body.append(media.data)
                   append(lineBreak, to: &body)
               }

        append("--\(boundary)--\(lineBreak)", to: &body)

        return body
    }

    func send<T>(urlRequest: URLRequest, parser: @escaping Parser<T>, completion: ((Result<T>) -> Void)?) {
        session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else {
                completion?(Result.failure(error: WebServiceError.invalidContext))
                return
            }
            self.completionHandler(data: data, response: response, error: error, parser: parser, completion: completion)
        }.resume()
    }

    func completionHandler<T>(data: Data?, response: URLResponse?, error: Error?, parser: Parser<T>, completion: ((Result<T>) -> Void)?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion?(Result.failure(error: WebServiceError.invalidHttpUrlResponse(data: data, response: response, error: error)))
            return
        }

        switch httpResponse.statusCode {
        case 200...299:
            if let data = data {
                do {
                    let parserData = try parser(data)
                    completion?(Result.success(value: parserData))
                } catch let parserError {
                    completion?(Result.failure(error: WebServiceError.parser(parserError)))
                }
            } else {
                completion?(Result.failure(error: WebServiceError.invalidDataResponse(data: data, response: response, error: error)))
            }
        default:
            completion?(Result.failure(error: WebServiceError.underlying(data: data, response: response, error: error)))
        }
    }

}

// MARK: - URLSessionDelegateWebService

private class URLSessionDelegateWebService: NSObject, URLSessionDelegate { }
