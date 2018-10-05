//
//  ConfigurationParser.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 05/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct ConfigurationParser: ParserProtocol {
    
    typealias T = Configuration
    
    static func parse(data: Data) -> T? {
        return try? T(data: data)
    }
}
