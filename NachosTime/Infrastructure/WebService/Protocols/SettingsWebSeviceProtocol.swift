//
//  SettingsWebServiceProtocol.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol SettingsWebServiceProtocol {
    func get(completion: @escaping ((Result<(configuration: Configuration?, genres: [Genre]?)>) -> Void))
}
