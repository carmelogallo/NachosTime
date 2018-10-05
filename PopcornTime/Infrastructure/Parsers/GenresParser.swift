//
//  GenresParser.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 05/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct GenresParser: ParserProtocol {
    
    typealias T = Genres
    
    static func parse(data: Data) -> T? {
        return try? T(data: data)
    }
}
