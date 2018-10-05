//
//  ApiProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 03/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol ApiProtocol {
    static var settings: SettingsWebSeviceProtocol { get }
    static var nowPlaying: NowPlayingWebServiceProtocol { get }
    static var search: SearchWebServiceProtocol { get }
}
