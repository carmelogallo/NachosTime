//
// Created by Carmelo Gallo on 4/22/17.
// Copyright (c) 2017 Carmelo Gallo. All rights reserved.
//

import Foundation

typealias Parser<T> = (Data) throws -> T

protocol WebServiceProtocol {
    func send<T>(request: WebServiceRequest, parser: @escaping Parser<T>, completion: ((Result<T>) -> Void)?)
    func send<T>(request: WebServiceRequest, medias: [WebServiceMedia], boundary: String, parser: @escaping Parser<T>, completion: ((Result<T>) -> Void)?)
}
