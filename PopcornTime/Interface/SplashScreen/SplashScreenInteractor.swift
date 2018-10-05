//
//  SplashScreenInteractor.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright (c) 2018 Carmelo Gallo. All rights reserved.
//

protocol SplashScreenBusinessLogic {
    func doGetSettings()
}

class SplashScreenInteractor: SplashScreenBusinessLogic {
    
    weak var viewController: SplashScreenDisplayLogic?

    // MARK: - Business logic
    
    func doGetSettings() {
        Api.settings.getSettings { [weak self] result in
            guard let values = result.value else {
                self?.viewController?.displayWebServiceErrorAlert()
                return
            }
            
            DataSource.settings.configutation = values.configuration
            DataSource.settings.genres = values.genres
            
            self?.viewController?.displayNowPlaying()
        }
    }
}
