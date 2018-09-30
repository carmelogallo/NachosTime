//
//  NowPlayingInteractor.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright (c) 2018 Carmelo Gallo. All rights reserved.
//

protocol NowPlayingBusinessLogic {
    func doGetNowPlaying()
    func doGetNextNowPlaying()
}

class NowPlayingInteractor: NowPlayingBusinessLogic {
    
    weak var viewController: NowPlayingDisplayLogic?

    // MARK: - Business logic
    func doGetNowPlaying() {
        MoviesDataSource.getNowPlaying { [weak self] resut in
            guard let movies = resut.value else {
                self?.viewController?.displayWebServiceErrorAlert()
                return
            }
            
            self?.viewController?.displayMovies(movies)
        }
    }
    
    func doGetNextNowPlaying() {
        MoviesDataSource.getNextNowPlaying { [weak self] resut in
            guard let movies = resut.value else {
                self?.viewController?.displayMovies([])
                return
            }
            
            self?.viewController?.displayMovies(movies)
        }
    }

}
