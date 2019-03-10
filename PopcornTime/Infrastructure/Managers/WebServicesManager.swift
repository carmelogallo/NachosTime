//
//  WebServicesManager.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 03/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

struct WebServicesManager {

    // MARK: - Private properties

    private let webService: WebServiceProtocol = URLSessionWebService()

    // MARK: - Internal properties

    private(set) var settings: SettingsWebServiceProtocol
    private(set) var nowPlaying: NowPlayingWebServiceProtocol
    private(set) var credits: CreditsWebServiceProtocol
    private(set) var search: SearchWebServiceProtocol

    // MARK: - Object lifecycle

    init() {
        settings = SettingsWebService(webService: webService)
        nowPlaying = NowPlayingWebService(webService: webService)
        credits = CreditsWebService(webService: webService)
        search = SearchWebService(webService: webService)
    }

}
