//
//  GenresParser.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 05/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct GenresParser {
    
    static var parse: Parser<Genres> = { data in
        return try JSONDecoder().decode(Genres.self, from: data)
    }

}
