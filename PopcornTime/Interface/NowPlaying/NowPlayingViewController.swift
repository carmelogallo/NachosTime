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
    
    var interactor: NowPlayingBusinessLogic?

    // MARK: - UI Objects
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Business Logic Objects

    private let reuseIdentifier = "NowPlayingCollectionViewCell"
    private var movies = [Movie]()
    private var isLoadingNextPage = false

    // MARK: - Object Lifecycle
    
    required init() {
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
        configureUI()
        configureConstraints()
    }

    private func configureUI() {
        // navigationController
        title = "Now Playing"
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = item

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
        interactor?.doGetFirstPage()
    }
    
    private func loadNextNowPlaying() {
        interactor?.doGetNextPage()
    }

}

// MARK: - NowPlayingDisplayLogic

extension NowPlayingViewController: NowPlayingDisplayLogic {
    
    func displayMovies(_ movies: [Movie]) {
        collectionView.performBatchUpdates({
            let currentLastIndex = self.movies.count
            let newLastIndex = currentLastIndex + movies.count - 1
            let indexes: [Int] = Array(currentLastIndex...newLastIndex)
            let indexPaths = indexes.map { IndexPath(item: $0, section: 0) }
            self.movies.append(contentsOf: movies)
            collectionView.insertItems(at: indexPaths)
        }, completion: { [weak self] success in
            self?.isLoadingNextPage = false
        })
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
        let movie = movies[indexPath.row]
        let vc = MovieDetailsViewController(withMovie: movie)
        navigationController?.pushViewController(vc, animated: true)
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
        // height should be the half size of the collectionView's width
        let width: CGFloat = floor(collectionView.bounds.width / 2)
        // height should be the 150% more than the width
        let height = width * 1.5
        
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

// MARK: - UIScrollViewDelegate

extension NowPlayingViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        guard !isLoadingNextPage && distance < scrollView.bounds.height else { return }
        
        isLoadingNextPage = true
        loadNextNowPlaying()
    }
}
