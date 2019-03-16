//
//  MoviesParser.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 05/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct MoviesParser {

    static var parse: Parser<Movies> = { data in
        return try JSONDecoder().decode(Movies.self, from: data)
    }

}
