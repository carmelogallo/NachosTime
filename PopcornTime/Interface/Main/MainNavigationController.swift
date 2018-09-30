//
//  MainNavigationController.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    // MARK: - View Lifecycle

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Configure Methods
    
    private func configure() {
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = textAttributes
    }

}
