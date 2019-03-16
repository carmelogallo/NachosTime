//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import Foundation

struct CreditsParser {

    static var parse: Parser<Credits> = { data in
        return try JSONDecoder().decode(Credits.self, from: data)
    }

}
