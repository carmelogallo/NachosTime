//
//  NowPlayingViewController.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol NowPlayingDisplayLogic: class {
    func displayNowPlaying()
    func insertNewItems(at indexPaths: [IndexPath], completion: @escaping (() -> Void))
    func displayWebServiceErrorAlert(_ alertController: UIAlertController)
}

class NowPlayingViewController: UIViewController {

    // MARK: - Business Logic

    private var viewModel: NowPlayingBusinessLogic = NowPlayingViewModel()

    // MARK: - UI Objects
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Object Lifecycle
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.viewController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        viewModel.loadNowPlaying()
    }

    // MARK: - Configure Methods

    private func configureUI() {
        // navigationController
        title = viewModel.title
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = item

        // view
        view.backgroundColor = .black
        
        // collectionView
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.registerCell(in: collectionView)
        view.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
 }

// MARK: - NowPlayingDisplayLogic

extension NowPlayingViewController: NowPlayingDisplayLogic {

    func displayNowPlaying() {
        collectionView.reloadData()
    }

    func insertNewItems(at indexPaths: [IndexPath], completion: @escaping (() -> Void)) {
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
        }, completion: { success in
            completion()
        })
    }

    func displayWebServiceErrorAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource

extension NowPlayingViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.cell(at: indexPath, in: collectionView)
    }

}

// MARK: - UICollectionViewDelegate

extension NowPlayingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieDetailsViewModel = viewModel.movieDetailsViewModel(at: indexPath) else {
            return
        }

        let viewController = MovieDetailsViewController(viewModel: movieDetailsViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.starDownloadTask(in: cell)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.cancelDownloadTask(in: cell)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension NowPlayingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItem(at: indexPath, in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSection
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSection
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSection
    }

}

// MARK: - UIScrollViewDelegate

extension NowPlayingViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        viewModel.loadNextItemsIfNeeded(in: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
