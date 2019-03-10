//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

protocol MovieDetailsBusinessLogic {
    func getSections(of movieId: Int)
}

class MovieDetailsInteractor {
    weak var viewController: MovieDetailsDisplayLogic?
    private var credits: Credits?
}

// MARK: - MovieDetailsBusinessLogic

extension MovieDetailsInteractor: MovieDetailsBusinessLogic {

    func getSections(of movieId: Int) {
        getCredits(of: movieId)
        getSimilar(of: movieId)
    }
}

// MARK: - Credits

private extension MovieDetailsInteractor {

    func getCredits(of movieId: Int) {
        Manager.webService.credits.get(of: movieId) { [weak self] result in
            switch result {
            case .success(let credits):
                self?.makeCastSection(credits)
                self?.makeCrewSection(credits)
            case .failure:
                return
            }
        }
    }

    func makeCastSection(_ credits: Credits) {
        let title = "Cast"
        let sectionInfo = credits.cast.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let section = MovieImageSection(title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

    func makeCrewSection(_ credits: Credits) {
        let title = "Crew"
        let sectionInfo = credits.crew.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let section = MovieImageSection(title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

}

// MARK: - Similar

private extension MovieDetailsInteractor {

    func getSimilar(of movieId: Int) {
        Manager.webService.similar.get(of: movieId) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.makeSimilarSection(movies)
            case .failure:
                return
            }
        }
    }

    func makeSimilarSection(_ movies: Movies) {
        let title = "Similar"
        let sectionInfo = movies.movies.map { MovieImageSection.Info(id: $0.id, imagePath: $0.posterPath) }
        let section = MovieImageSection(title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

}
