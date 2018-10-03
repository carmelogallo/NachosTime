//
//  SettingsDataSourceProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol SettingsDataSourceProtocol {
    var configutation: Configuration? { get set }
    var genres: [Genre]? { get set }
}
