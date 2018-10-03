//
//  NowPlayingInteractor.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright (c) 2018 Carmelo Gallo. All rights reserved.
//

protocol NowPlayingBusinessLogic {
    func doGetFirstPage()
    func doGetNextPage()
}

class NowPlayingInteractor: NowPlayingBusinessLogic {
    
    weak var viewController: NowPlayingDisplayLogic?

    // MARK: - Private Properties

    private var page: Int {
        var page = DataSource.nowPlaying.movies?.page ?? 0
        page += 1
        
        return page
    }
    
    // MARK: - Business logic
    
    func doGetFirstPage() {
        doGet(at: 1)
    }
    
    func doGetNextPage() {
        doGet(at: page)
    }

    // MARK: - Private Methods

    func doGet(at page: Int) {
        Api.nowPlaying.get(at: page) { [weak self] resut in
            guard let movies = resut.value else {
                self?.viewController?.displayWebServiceErrorAlert()
                return
            }
            
            DataSource.nowPlaying.movies = movies
            
            self?.viewController?.displayMovies(movies.movies)
        }

    }
}
