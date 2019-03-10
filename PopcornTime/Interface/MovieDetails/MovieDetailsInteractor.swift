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
    }
}

// MARK: - Credits

private extension MovieDetailsInteractor {

    func getCredits(of movieId: Int) {
        Manager.webService.credits.get(of: movieId) { [weak self] result in
            switch result {
            case .success(let credits):
                self?.makeCastInfo(credits)
                self?.makeCrewInfo(credits)
            case .failure:
                return
            }
        }
    }

    func makeCastInfo(_ credits: Credits) {
        let title = "Cast"
        let sectionInfo = credits.cast.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let section = MovieImageSection(title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

    func makeCrewInfo(_ credits: Credits) {
        let title = "Crew"
        let sectionInfo = credits.crew.unique.map { MovieImageSection.Info(id: $0.id, imagePath: $0.profilePath, text: $0.name) }
        let section = MovieImageSection(title: title, info: sectionInfo)
        viewController?.displayImageSection(section)
    }

}
