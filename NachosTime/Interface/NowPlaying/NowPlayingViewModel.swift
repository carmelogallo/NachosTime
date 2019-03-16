//
//  NowPlayingViewModel.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright (c) 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol NowPlayingBusinessLogic {
    var viewController: NowPlayingDisplayLogic? { get set }
    var title: String { get }
    var numberOfSections: Int { get }
    var numberOfItemsInSection: Int { get }
    var insetForSection: UIEdgeInsets { get }
    var minimumLineSpacingForSection: CGFloat { get }
    var minimumInteritemSpacingForSection: CGFloat { get }

    func registerCell(in collectionView: UICollectionView)
    func cell(at indexPath: IndexPath, in collectionView: UICollectionView) -> NowPlayingCollectionViewCell
    func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize
    func starDownloadTask(in cell: UICollectionViewCell)
    func cancelDownloadTask(in cell: UICollectionViewCell)
    func loadNowPlaying()
    func loadNextItemsIfNeeded(in scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    func movieDetailsViewModel(at indexPath: IndexPath) -> MovieDetailsViewModel?
}

class NowPlayingViewModel: NowPlayingBusinessLogic {

    // MARK: - Business logic properties

    weak var viewController: NowPlayingDisplayLogic?

    var title: String {
        return "Now Playing"
    }

    var numberOfSections: Int {
        return 1
    }

    var numberOfItemsInSection: Int {
        return movies?.movies.count ?? 0
    }

    var insetForSection: UIEdgeInsets {
        return .zero
    }

    var minimumLineSpacingForSection: CGFloat {
        return 0
    }

    var minimumInteritemSpacingForSection: CGFloat {
        return 0
    }

    // MARK: - Private properties

    private let reuseIdentifier: String = "NowPlayingCollectionViewCell"
    private var page: Int {
        let page = movies?.page ?? 0
        return page + 1
    }
    private var movies: Movies?
    private var isLoadingNextPage = false

    // MARK: - Business logic methods

    func registerCell(in collectionView: UICollectionView) {
        collectionView.register(NowPlayingCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func cell(at indexPath: IndexPath, in collectionView: UICollectionView) -> NowPlayingCollectionViewCell {
        guard let movie = movies?.movies[indexPath.item] else {
            assertionFailure("imageSection is nil!")
            return NowPlayingCollectionViewCell()
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NowPlayingCollectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return NowPlayingCollectionViewCell()
        }

        cell.configure(movie: movie)

        return cell
    }

    func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize {
        // width should be the half size of the collectionView's width
        let width: CGFloat = floor(collectionView.bounds.width / 2)
        // height should be the 150% more than the width
        let height = width * 1.5

        return CGSize(width: width, height: height)
    }

    func starDownloadTask(in cell: UICollectionViewCell) {
        guard let cell = cell as? NowPlayingCollectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return
        }

        cell.starDownloadTask()
    }

    func cancelDownloadTask(in cell: UICollectionViewCell) {
        guard let cell = cell as? NowPlayingCollectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return
        }

        cell.cancelDownloadTask()
    }

    func loadNowPlaying() {
        doGet(at: 1)
    }

    func loadNextItemsIfNeeded(in scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.width - (targetContentOffset.pointee.x + scrollView.bounds.width)
        guard !isLoadingNextPage && distance < scrollView.bounds.width else {
            return
        }

        isLoadingNextPage = true
        doGet(at: page)
    }

    func movieDetailsViewModel(at indexPath: IndexPath) -> MovieDetailsViewModel? {
        guard let movie = movies?.movies[indexPath.row] else {
            return nil
        }

        return MovieDetailsViewModel(movie: movie)
    }

}

// MARK: - Private

private extension NowPlayingViewModel {

    func doGet(at page: Int) {
        Manager.webService.nowPlaying.get(at: page) { [weak self] result in
            guard let self = self else {
                return
            }

            guard let movies = result.value else {
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

            guard !movies.movies.isEmpty else {
                return
            }

            let currentImageSectionInfoCount = self.movies?.movies.count ?? 0

            if self.movies == nil || currentImageSectionInfoCount == 0{
                self.movies = movies
                self.viewController?.displayNowPlaying()
            } else {
                let currentLastIndex = currentImageSectionInfoCount
                let newLastIndex = currentLastIndex + movies.movies.count - 1
                let indexes: [Int] = Array(currentLastIndex...newLastIndex)
                let indexPaths = indexes.map {
                    IndexPath(item: $0, section: 0)
                }
                self.movies?.movies.append(contentsOf: movies.movies)
                self.viewController?.insertNewItems(at: indexPaths) {
                    self.isLoadingNextPage = false
                }
            }
        }

    }

}
