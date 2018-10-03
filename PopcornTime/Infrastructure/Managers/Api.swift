//
//  Api.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 03/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

struct Api: ApiProtocol {
    
    static private(set) var webService: WebServiceProtocol = URLSessionWebService()
    static private(set) var settings: SettingsWebSeviceProtocol = SettingsWebService(webService: Api.webService)
    static private(set) var nowPlaying: NowPlayingWebServiceProtocol = NowPlayingWebService(webService: Api.webService)
    static private(set) var search: SearchWebServiceProtocol = SearchWebService(webService: Api.webService)

    private init() { /* Required for a better protection */ }
}
