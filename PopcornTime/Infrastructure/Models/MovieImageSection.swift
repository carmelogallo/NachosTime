//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import Foundation

struct MovieImageSection {
    enum Context {
        case cast
        case crew
        case similar
    }

    struct Info {
        let id: Int
        let imagePath: String?
        let text: String?

        init(id: Int, imagePath: String?, text: String? = nil) {
            self.id = id
            self.imagePath = imagePath
            self.text = text
        }
    }

    let context: Context
    let title: String
    let info: [Info]
}
