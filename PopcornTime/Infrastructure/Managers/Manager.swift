//
// Created by Carmelo Gallo on 2019-03-08.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

enum Manager {
    static let config = ConfigurationManager()
    static let webService = WebServicesManager()
    static var dataSource = DataSourceManager()
}
