//
//  SplashScreenViewModel.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright (c) 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol SplashScreenBusinessLogic {
    var viewController: SplashScreenDisplayLogic? { get set }

    func loadSettings()
}

class SplashScreenViewModel: SplashScreenBusinessLogic {
    
    weak var viewController: SplashScreenDisplayLogic?

    // MARK: - Business logic
    
    func loadSettings() {
        Manager.webService.settings.get { [weak self] result in
            guard let self = self else {
                return
            }

            guard let values = result.value else {
                let alertController = UIAlertController(title: "Ops!",
                                                        message: "Something went wrong.\nPlease try again later.",
                                                        preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                    exit(0)
                })
                alertController.addAction(dismiss)

                self.viewController?.displayWebServiceErrorAlert(alertController)

                return
            }
            
            Manager.dataSource.settings.configuration = values.configuration
            Manager.dataSource.settings.genres = values.genres
            
            self.viewController?.displayNowPlaying()
        }
    }
}
