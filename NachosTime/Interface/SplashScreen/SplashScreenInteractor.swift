//
//  SplashScreenInteractor.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright (c) 2018 Carmelo Gallo. All rights reserved.
//

protocol SplashScreenBusinessLogic {
    func doGetSettings()
}

// todo: change this to a view model!
class SplashScreenInteractor: SplashScreenBusinessLogic {
    
    weak var viewController: SplashScreenDisplayLogic?

    // MARK: - Business logic
    
    func doGetSettings() {
        Manager.webService.settings.get { [weak self] result in
            guard let values = result.value else {
                self?.viewController?.displayWebServiceErrorAlert()
                return
            }
            
            Manager.dataSource.settings.configuration = values.configuration
            Manager.dataSource.settings.genres = values.genres
            
            self?.viewController?.displayNowPlaying()
        }
    }
}
