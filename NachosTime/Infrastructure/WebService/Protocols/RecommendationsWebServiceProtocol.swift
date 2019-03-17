//
// Created by Carmelo Gallo on 2019-03-17.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

protocol RecommendationsWebServiceProtocol {
    func get(of movieId: Int, at page: Int, completion: @escaping ((Result<Movies>) -> Void))
}
