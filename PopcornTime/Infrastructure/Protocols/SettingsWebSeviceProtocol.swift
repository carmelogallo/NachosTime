//
//  SettingsWebSeviceProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol SettingsWebSeviceProtocol {
    var webService: WebServiceProtocol { get }
    
    init(webService: WebServiceProtocol)
    func getSettings(completion: @escaping ((Result<(configuration: Configuration?, genres: [Genre]?)>) -> Void))
}
