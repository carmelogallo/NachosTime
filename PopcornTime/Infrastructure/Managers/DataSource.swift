//
//  DataSource.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 03/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

struct DataSource: DataSourceProtocol {

    // MARK: - DataSourceProtocol Properties

    static var settings: SettingsDataSourceProtocol = SettingsDataSource()
    static var nowPlaying: NowPlayingDataSourceProtocol = NowPlayingDataSource()
    static var search: SearchDataSourceProtocol = SearchDataSource()

    // MARK: - Object Lifecycle

    private init() { /* Required for a better protection */ }
}
