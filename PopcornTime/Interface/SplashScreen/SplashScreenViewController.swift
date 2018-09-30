//
//  SplashScreenViewController.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol SplashScreenDisplayLogic: class {
    func displayNowPlaying()
    func displayWebServiceErrorAlert()
}

class SplashScreenViewController: UIViewController {

    // Business Logic
    
    var interactor: SplashScreenBusinessLogic?

    // MARK: - UI Objects

    private let logoImageView = UIImageView(frame: .zero)
    private let activityIndicatorView = UIActivityIndicatorView(style: .white)
    
    // MARK: - Object Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setupLogic()
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
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }
    
    // MARK: - Setup Methods
    
    private func setupLogic() {
        let viewController = self
        let interactor = SplashScreenInteractor()
        viewController.interactor = interactor
        interactor.viewController = viewController
    }
    
    // MARK: - Configure Methods
    
    private func configureViews() {
        configureObjects()
        configureConstraints()
    }
    
    private func configureObjects() {
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
        // logoImageView
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // activityIndicatorView
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    private func loadSettings() {
        interactor?.doGetSettings()
    }

}

// MARK: - SplashScreenDisplayLogic

extension SplashScreenViewController: SplashScreenDisplayLogic {

    func displayNowPlaying() {
        let vc = NowPlayingViewController()
        let nvc = NowPlayingNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }
    
    func displayWebServiceErrorAlert() {
        let alertController = UIAlertController(title: "Ops!",
                                                message: "Samething went wrong.\nPlease try again later.",
                                                preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
            exit(0)
        })
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }

}
