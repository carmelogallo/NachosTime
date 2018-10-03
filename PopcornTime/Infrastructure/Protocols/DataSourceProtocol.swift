//
//  DataSourceProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 03/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol DataSourceProtocol {
    static var settings: SettingsDataSourceProtocol { get }
    static var nowPlaying: NowPlayingDataSourceProtocol { get }
    static var search: SearchDataSourceProtocol { get }
}
