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
    
    weak var viewController: SplashScreenViewController?

    // MARK: - Business logic
    
    func doGetSettings() {
        SettingsDataSource.getSettings { [weak self] result in
            guard let success = result.value, success else {
                self?.viewController?.displayWebServiceErrorAlert()
                return
            }
            
            self?.viewController?.displayNowPlaying()
        }
    }
}
