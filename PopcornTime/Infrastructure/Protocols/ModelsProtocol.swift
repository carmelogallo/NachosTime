//
//  ModelsProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 29/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

protocol ModelsProtocol: Decodable {
    init(data: Data) throws
}
