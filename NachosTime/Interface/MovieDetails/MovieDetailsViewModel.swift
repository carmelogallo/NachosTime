//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//
import Foundation

protocol MovieDetailsBusinessLogic {
    var viewController: MovieDetailsDisplayLogic? { get set }
    var backdropPath: String? { get }
    var title: String { get }
    var movieTitle: String { get }
    var voteAverage: Float { get }
    var genres: String? { get }
    var overview: String { get }

    func loadSections()
}

class MovieDetailsViewModel: MovieDetailsBusinessLogic {

    // MARK: - Business logic properties

    weak var viewController: MovieDetailsDisplayLogic?

    var backdropPath: String? {
        guard let baseUrl = Manager.dataSource.settings.configuration?.images.baseUrl,
              let backdropSize = Manager.dataSource.settings.configuration?.images.backdropSizeValue(.w780),
              let backdropPath = movie.backdropPath else {
            return nil
        }

        return baseUrl + backdropSize + backdropPath
    }

    var title: String {
        return movie.title
    }

    var movieTitle: String {
        return movie.title
    }

    var voteAverage: Float {
        return movie.voteAverage
    }

    var genres: String? {
        return movie.genres
    }

    var overview: String {
        return movie.overview
    }

    // MARK: - Private properties

    private let movie: Movie

    // MARK: - Object lifecycle

    init(movie: Movie) {
        self.movie = movie
    }

    // MARK: - Business logic methods

    func loadSections() {
        loadCredits() { [weak self] in
            guard let self = self else {
                return
            }

            // load sections that doesn't need a backend call
            self.displaySimilarSection()
            self.displayRecommendationsSection()
        }
    }

}

private extension MovieDetailsViewModel {

    func loadCredits(completion: @escaping (() -> Void)) {
        Manager.webService.credits.get(of: movie.id) { [weak self] result in
            guard let self = self, let viewController = self.viewController else {
                return
            }

            switch result {
            case .success(let credits):
                let castSectionViewModel = MovieImageSectionViewModel(presentingViewController: viewController, flow: .cast, movieId: self.movie.id, credits: credits)
                viewController.displaySection(viewModel: castSectionViewModel)

                let crewSectionViewModel = MovieImageSectionViewModel(presentingViewController: viewController, flow: .crew, movieId: self.movie.id, credits: credits)
                viewController.displaySection(viewModel: crewSectionViewModel)
            case .failure:
                break
            }

            completion()
        }
    }

    func displaySimilarSection() {
        guard let viewController = viewController else {
            return
        }

        let viewModel = MovieImageSectionViewModel(presentingViewController: viewController, flow: .similar, movieId: movie.id)
        viewController.displaySection(viewModel: viewModel)
    }

    func displayRecommendationsSection() {
        guard let viewController = viewController else {
            return
        }

        let viewModel = MovieImageSectionViewModel(presentingViewController: viewController, flow: .recommendations, movieId: movie.id)
        viewController.displaySection(viewModel: viewModel)
    }

}
