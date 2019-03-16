//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//
import Foundation

protocol MovieDetailsBusinessLogic {
    var viewController: MovieDetailsDisplayLogic? { get set }
    var backdropPath: String? { get }
    var title: String { get }
    var voteAverage: Float { get }
    var genres: String? { get }
    var overview: String { get }

    func getSections()
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

    func getSections() {
        getCredits()
    }

}

private extension MovieDetailsViewModel {

    func getCredits() {
        Manager.webService.credits.get(of: movie.id) { [weak self] result in
            guard let self = self, let viewController = self.viewController else {
                return
            }

            switch result {
            case .success(let credits):
                let castSectionViewModel = MovieImageSectionViewModel(presentingViewController: viewController, flow: .cast, movieId: self.movie.id, credits: credits)
                viewController.displayCastSections(viewModel: castSectionViewModel)

                let crewSectionViewModel = MovieImageSectionViewModel(presentingViewController: viewController, flow: .crew, movieId: self.movie.id, credits: credits)
                viewController.displayCastSections(viewModel: crewSectionViewModel)
            case .failure:
                break
            }

            self.displaySimilarSection()
        }
    }

    func displaySimilarSection() {
        guard let viewController = viewController else {
            return
        }

        let viewModel = MovieImageSectionViewModel(presentingViewController: viewController, flow: .similar, movieId: movie.id)
        viewController.displaySimilarSection(viewModel: viewModel)
    }

}
