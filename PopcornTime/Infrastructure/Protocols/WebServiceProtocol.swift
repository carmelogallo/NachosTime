//
//  WebServiceProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 03/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

protocol WebServiceProtocol {
    
    static var baseUrl: String { get }
    
    static func call(webServiceRequest: WebServiceRequest, completion: @escaping ((Result<Data>) -> Void))
}
