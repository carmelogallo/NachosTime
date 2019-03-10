//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

protocol MovieImageSectionBusinessLogic {
    func getCastSection(_ credits: Credits)
    func getCrewSection(_ credits: Credits)
    func getSimilar(of movieId: Int)
}

class MovieImageSectionInteractor {
    weak var viewController: MovieImageSectionDisplayLogic?
    private var credits: Credits?
}

// MARK: - MovieDetailsBusinessLogic

extension MovieImageSectionInteractor: MovieImageSectionBusinessLogic {

    func getCastSection(_ credits: Credits) {
        let title = "Cast"
        let sectionInfo = credits.cast.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let section = MovieImageSection(context: .cast, title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

    func getCrewSection(_ credits: Credits) {
        let title = "Crew"
        let sectionInfo = credits.crew.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let section = MovieImageSection(context: .crew, title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

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

}


// MARK: - Similar

private extension MovieImageSectionInteractor {

    func makeSimilarSection(_ movies: Movies) {
        let title = "Similar"
        let sectionInfo = movies.movies.map { MovieImageSection.Info(id: $0.id, imagePath: $0.posterPath) }
        let section = MovieImageSection(context: .similar, title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

}
