//
// Created by Carmelo Gallo on 2019-03-07.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

struct WebServiceRequest {

    // MARK: - Internal properties

    typealias Path = (url: String, query: [String: String]?)
    typealias Body = (data: [String: Any], encoding: Encoding)

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    enum Encoding {
        case json
        case urlEncoded
    }

    let method: HTTPMethod
    let path: Path
    let headers: [String: String]?
    let body: Body?

    // MARK: - Object lifecycle

    init(method: HTTPMethod, path: Path, headers: [String: String]? = nil, body: Body? = nil) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
}
