//
//  ConfigurationParser.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 05/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct ConfigurationParser {

    static var parse: Parser<Configuration> = { data in
        return try JSONDecoder().decode(Configuration.self, from: data)
    }

}
