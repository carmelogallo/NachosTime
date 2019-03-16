//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

extension Array where Element: Hashable {

    var unique: [Element] {
        var result = [Element]()
        self.forEach {
            if !result.contains($0) {
                result.append($0)
            }
        }
        return result
    }

}