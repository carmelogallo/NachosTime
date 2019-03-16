//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

protocol SimilarWebServiceProtocol {
    func get(of movieId: Int, at page: Int, completion: @escaping ((Result<Movies>) -> Void))
}
