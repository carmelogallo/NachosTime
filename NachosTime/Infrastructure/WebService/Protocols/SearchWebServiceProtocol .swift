//
//  SearchWebServiceProtocol.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol SearchWebServiceProtocol {
    func get(at page:Int, keyWords: String, completion: @escaping ((Result<[Movie]>) -> Void))
}
