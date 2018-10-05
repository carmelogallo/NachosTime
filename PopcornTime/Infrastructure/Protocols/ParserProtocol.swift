//
//  ParserProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 05/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    associatedtype T
    
    static func parse(data: Data) -> T?
}
