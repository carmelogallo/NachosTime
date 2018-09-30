//
//  NowPlayingViewController.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol NowPlayingDisplayLogic: class {
    func displayMovies(_ movies: [Movie])
    func displayWebServiceErrorAlert()
}

class NowPlayingViewController: UIViewController {

    // Business Logic
    
    var interactor: NowPlayingInteractor?

    // MARK: - UI Objects
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Business Logic Objects

    private let reuseIdentifier = "NowPlayingCollectionViewCell"
    private var movies = [Movie]()
    
    // MARK: - Object Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setupLogic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNowPlaying()
    }
    
    // MARK: - Setup Methods
    
    private func setupLogic() {
        let viewController = self
        let interactor = NowPlayingInteractor()
        viewController.interactor = interactor
        interactor.viewController = viewController
    }

    // MARK: - Configure Methods

    private func configureViews() {
        configureObjects()
        configureConstraints()
    }

    private func configureObjects() {
        // navigationController
        title = "Now Playing"
        navigationController?.navigationItem.largeTitleDisplayMode = .never

        // view
        view.backgroundColor = .black
        
        // collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NowPlayingCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        // collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    private func loadNowPlaying() {
        interactor?.doGetNowPlaying()
    }
    
    private func loadNextNowPlaying() {
        interactor?.doGetNextNowPlaying()
    }

}

// MARK: - NowPlayingDisplayLogic

extension NowPlayingViewController: NowPlayingDisplayLogic {
    
    func displayMovies(_ movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
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

// MARK: - UICollectionViewDataSource

extension NowPlayingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NowPlayingCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        }
        
        let movie = movies[indexPath.item]
        cell.configure(withMovie: movie)
        
        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension NowPlayingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(movies[indexPath.row].originalTitle)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? NowPlayingCollectionViewCell else {
            return
        }
        
        cell.starDownloadTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? NowPlayingCollectionViewCell else {
            return
        }
        
        cell.cancelDownloadTask()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension NowPlayingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = floor(collectionView.bounds.width / 2)
        let height = width / 2 * 3
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
