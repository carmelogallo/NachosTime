//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//
import Foundation

protocol MovieDetailsBusinessLogic {
    func getSections(of movieId: Int)
}

class MovieDetailsInteractor {
    weak var viewController: MovieDetailsDisplayLogic?
}

// MARK: - MovieDetailsBusinessLogic

extension MovieDetailsInteractor: MovieDetailsBusinessLogic {

    func getSections(of movieId: Int) {
        getCredits(of: movieId)
    }

}

private extension MovieDetailsInteractor {

    func getCredits(of movieId: Int) {
        Manager.webService.credits.get(of: movieId) { [weak self] result in
            switch result {
            case .success(let credits):
                self?.viewController?.displayCreditsSections(credits)
            case .failure:
                break
            }

            self?.displaySimilarSection()
        }
    }

    func displaySimilarSection() {
        viewController?.displaySimilarSection()
    }

}
