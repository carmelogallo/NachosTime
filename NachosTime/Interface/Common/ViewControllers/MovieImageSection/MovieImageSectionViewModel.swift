//
// Created by Carmelo Gallo on 2019-03-16.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol MovieImageSectionBusinessLogic {
    var presentingViewController: MovieDetailsDisplayLogic? { get set }
    var viewController: MovieImageSectionDisplayLogic? { get set }
    var title: String? { get }
    var numberOfSections: Int { get }
    var numberOfItemsInSection: Int { get }
    var insetForSection: UIEdgeInsets { get }
    var minimumLineSpacingForSection: CGFloat { get }
    var minimumInteritemSpacingForSection: CGFloat { get }

    func loadSection()
    func collectionViewHeightDelta(in view: UIView) -> CGFloat
    func registerCell(in collectionView: UICollectionView)
    func cell(at indexPath: IndexPath, in collectionView: UICollectionView) -> MovieImageSectionViewCell
    func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize
    func starDownloadTask(in cell: UICollectionViewCell)
    func cancelDownloadTask(in cell: UICollectionViewCell)
    func loadNextItemsIfNeeded(in scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    func didSelectItem(at indexPath: IndexPath)
}

class MovieImageSectionViewModel: MovieImageSectionBusinessLogic {

    // MARK: - Business logic properties

    weak var presentingViewController: MovieDetailsDisplayLogic?
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
    private var movies = [Movie]()
    private let movieId: Int
    private let credits: Credits?
    private var imageSection: MovieImageSection?
    private var page = 1
    private var totalPages = 1
    private var isLoadingNextPage = false

    // MARK: - Object lifecycle

    init(presentingViewController: MovieDetailsDisplayLogic, flow: MovieImageSection.Flow, movieId: Int, credits: Credits? = nil) {
        self.presentingViewController = presentingViewController
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
            loadSimilar()
        case .recommendations:
            loadRecommendations()
        }
    }

    func collectionViewHeightDelta(in view: UIView) -> CGFloat {
        let delta: CGFloat
        switch flow {
        case .crew, .cast:
            delta = 0.5
        case .similar, .recommendations:
            delta = 0.7
        }
        return view.bounds.width / 4 * 3 * delta
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

    func loadNextItemsIfNeeded(in scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard [MovieImageSection.Flow.similar, MovieImageSection.Flow.recommendations].contains(flow) else {
            return
        }

        guard page < totalPages else {
            return
        }

        let distance = scrollView.contentSize.width - (targetContentOffset.pointee.x + scrollView.bounds.width)
        guard targetContentOffset.pointee.y > 0 && !isLoadingNextPage && distance < scrollView.bounds.width else {
            return
        }

        isLoadingNextPage = true

        if case .similar = flow {
            loadSimilar()
        } else if case .recommendations = flow {
            loadRecommendations()
        }
    }

    func didSelectItem(at indexPath: IndexPath) {
        switch flow {
        case .crew, .cast:
//            let people = movies[indexPath.item]
            break
        case .similar, .recommendations:
            let movie = movies[indexPath.item]
            presentingViewController?.displayMovie(movie)
        }
    }

}


// MARK: - Similar

private extension MovieImageSectionViewModel {

    // MARK: Cast

    func displayCastSection(_ credits: Credits) {
        let title = "Cast"
        let sectionInfo = credits.cast.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let imageSection = MovieImageSection(flow: .cast, title: title, info: sectionInfo)
        displaySectionIfNeeded(imageSection)
    }

    // MARK: Crew

    func displayCrewSection(_ credits: Credits) {
        let title = "Crew"
        let sectionInfo = credits.crew.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let imageSection = MovieImageSection(flow: .crew, title: title, info: sectionInfo)
        displaySectionIfNeeded(imageSection)
    }

    // MARK: Similar

    func loadSimilar() {
        Manager.webService.similar.get(of: movieId, at: page) { [weak self] result in
            self?.processMoviesResult(result, title: "Similar", flow: .similar)
        }
    }

    func loadRecommendations() {
        Manager.webService.recommendations.get(of: movieId, at: page) { [weak self] result in
            self?.processMoviesResult(result, title: "Recommendations", flow: .recommendations)
        }
    }

    func processMoviesResult(_ result: Result<Movies>, title: String, flow: MovieImageSection.Flow) {
        switch result {
        case .success(let movies):
            self.movies.append(contentsOf: movies.movies)
            totalPages = movies.totalPages
            page = movies.page
            displaySectionIfNeeded(from: movies, title: title, flow: flow)
        case .failure:
            return
        }
    }

    func displaySectionIfNeeded(from movies: Movies, title: String, flow: MovieImageSection.Flow) {
        let sectionInfo = movies.movies.map { MovieImageSection.Info(id: $0.id, imagePath: $0.posterPath) }
        let imageSection = MovieImageSection(flow: flow, title: title, info: sectionInfo)
        displaySectionIfNeeded(imageSection)
    }

    // MARK: Displaying logic

    func displaySectionIfNeeded(_ imageSection: MovieImageSection) {
        let currentImageSectionInfoCount = self.imageSection?.info.count ?? 0
        let nextImageSectionInfoCount = imageSection.info.count

        if currentImageSectionInfoCount == 0 && nextImageSectionInfoCount == 0 {
            guard let section = viewController as? MovieImageSectionViewController else {
                assertionFailure("viewController is nil not a MovieImageSectionViewController!")
                return
            }
            presentingViewController?.removeSection(section: section)
        } else {

            if self.imageSection == nil || currentImageSectionInfoCount == 0{
                self.imageSection = imageSection
                viewController?.displaySection()
            } else {
                let currentLastIndex = currentImageSectionInfoCount
                let newLastIndex = currentLastIndex + nextImageSectionInfoCount - 1
                let indexes: [Int] = Array(currentLastIndex...newLastIndex)
                let indexPaths = indexes.map { IndexPath(item: $0, section: 0) }
                self.imageSection?.info.append(contentsOf: imageSection.info)
                viewController?.insertNewItems(at: indexPaths) {
                    self.isLoadingNextPage = false
                }
            }
        }
     }
}
