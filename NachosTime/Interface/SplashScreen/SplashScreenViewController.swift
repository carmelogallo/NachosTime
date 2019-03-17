//
//  SplashScreenViewController.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol SplashScreenDisplayLogic: class {
    func displayNowPlaying()
    func displayWebServiceErrorAlert(_ alertController: UIAlertController)
}

class SplashScreenViewController: UIViewController {

    // Business Logic
    
    private var viewModel: SplashScreenBusinessLogic = SplashScreenViewModel()

    // MARK: - UI Objects

    private let logoImageView = UIImageView(frame: .zero)
    private let activityIndicatorView = UIActivityIndicatorView(style: .white)
    
    // MARK: - Object Lifecycle

    required init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.viewController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure
        configureUI()
        configureConstraints()
        // loading settings
        viewModel.loadSettings()
    }

    // MARK: - Configure Methods
    
    private func configureUI() {
        // view
        view.backgroundColor = .black
        
        // logoImageView
        logoImageView.image = UIImage(named: "logo")
        view.addSubview(logoImageView)
        
        // activityIndicatorView
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
    }
    
    private func configureConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            // logoImageView
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // activityIndicatorView
            activityIndicatorView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

}

// MARK: - SplashScreenDisplayLogic

extension SplashScreenViewController: SplashScreenDisplayLogic {

    func displayNowPlaying() {
        let vc = NowPlayingViewController()
        let nvc = NowPlayingNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    func displayWebServiceErrorAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }

}
