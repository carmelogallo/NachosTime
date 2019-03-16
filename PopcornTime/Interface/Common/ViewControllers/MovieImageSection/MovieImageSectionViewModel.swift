//
// Created by Carmelo Gallo on 2019-03-16.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol MovieImageSectionBusinessLogic {
    var viewController: MovieImageSectionDisplayLogic? { get set }
    var title: String? { get }
    var numberOfSections: Int { get }
    var numberOfItemsInSection: Int { get }
    var insetForSection: UIEdgeInsets { get }
    var minimumLineSpacingForSection: CGFloat { get }
    var minimumInteritemSpacingForSection: CGFloat { get }

    func loadSection()
    func registerCell(in collectionView: UICollectionView)
    func cell(at indexPath: IndexPath, in collectionView: UICollectionView) -> MovieImageSectionViewCell
    func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize
    func starDownloadTask(in cell: UICollectionViewCell)
    func cancelDownloadTask(in cell: UICollectionViewCell)
}

class MovieImageSectionViewModel: MovieImageSectionBusinessLogic {

    // MARK: - Business logic properties

    weak var viewController: MovieImageSectionDisplayLogic?

    var title: String? {
        return imageSection?.title
    }

    var numberOfSections: Int {
        return 1
    }

    var numberOfItemsInSection: Int {
        return imageSection?.info.count ?? 0
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

    private let reuseIdentifier = "MovieImageSectionViewCell"
    private let flow: MovieImageSection.Flow
    private let movieId: Int
    private let credits: Credits?
    private var imageSection: MovieImageSection?

    // MARK: - Object lifecycle

    init(flow: MovieImageSection.Flow, movieId: Int, credits: Credits? = nil) {
        self.flow = flow
        self.movieId = movieId
        self.credits = credits
    }

    // MARK: - Business logic methods

    func loadSection() {
        switch flow {
        case .crew:
            guard let credits = credits else {
                assertionFailure("credits is nil!")
                return
            }
            displayCrewSection(credits)
        case .cast:
            guard let credits = credits else {
                assertionFailure("credits is nil!")
                return
            }
            displayCastSection(credits)
        case .similar:
            getSimilar(of: movieId)
        }
    }

    func registerCell(in collectionView: UICollectionView) {
        collectionView.register(MovieImageSectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func cell(at indexPath: IndexPath, in collectionView: UICollectionView) -> MovieImageSectionViewCell {
        guard let sectionInfo = imageSection?.info[indexPath.item] else {
            assertionFailure("imageSection is nil!")
            return MovieImageSectionViewCell()
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MovieImageSectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return MovieImageSectionViewCell()
        }

        cell.configure(sectionInfo: sectionInfo)

        return cell
    }

    func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize {
        // we display the cell with a 16/9 aspect ratio in base of the height
        let height = collectionView.bounds.height
        let width: CGFloat = floor(height * 3 / 4)
        return CGSize(width: width, height: height)
    }

    func starDownloadTask(in cell: UICollectionViewCell) {
        guard let cell = cell as? MovieImageSectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return
        }

        cell.starDownloadTask()
    }

    func cancelDownloadTask(in cell: UICollectionViewCell) {
        guard let cell = cell as? MovieImageSectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return
        }

        cell.cancelDownloadTask()
    }

}


// MARK: - Similar

private extension MovieImageSectionViewModel {

    // MARK: Cast

    func displayCastSection(_ credits: Credits) {
        let title = "Cast"
        let sectionInfo = credits.cast.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        imageSection = MovieImageSection(flow: .cast, title: title, info: sectionInfo)
        viewController?.displayImageSection()
    }

    // MARK: Crew

    func displayCrewSection(_ credits: Credits) {
        let title = "Crew"
        let sectionInfo = credits.crew.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        imageSection = MovieImageSection(flow: .crew, title: title, info: sectionInfo)
        viewController?.displayImageSection()
    }

    // MARK: Similar

    func getSimilar(of movieId: Int) {
        Manager.webService.similar.get(of: movieId) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.displaySimilarSection(movies)
            case .failure:
                return
            }
        }
    }

    func displaySimilarSection(_ movies: Movies) {
        let title = "Similar"
        let sectionInfo = movies.movies.map { MovieImageSection.Info(id: $0.id, imagePath: $0.posterPath) }
        imageSection = MovieImageSection(flow: .similar, title: title, info: sectionInfo)
        viewController?.displayImageSection()
    }

}
