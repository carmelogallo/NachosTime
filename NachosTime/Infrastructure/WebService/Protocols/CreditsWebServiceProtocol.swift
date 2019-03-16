//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

protocol CreditsWebServiceProtocol {
    func get(of movieId: Int, completion: @escaping ((Result<Credits>) -> Void))
}
