//
//  NowPlayingWebServiceProtocol.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol NowPlayingWebServiceProtocol {
    func get(at page: Int, completion: @escaping ((Result<Movies>) -> Void))
}
