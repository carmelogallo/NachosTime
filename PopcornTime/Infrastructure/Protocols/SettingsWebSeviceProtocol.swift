//
//  SettingsWebSeviceProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol SettingsWebSeviceProtocol {
    static func getSettings(completion: @escaping ((Result<Bool>) -> Void))
}
