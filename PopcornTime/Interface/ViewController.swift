//
//  ViewController.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.red
        
        let button = UIButton(frame: .zero)
        button.setTitle("get", for: .normal)
        button.addTarget(self, action: #selector(get), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    func get() {
        SettingsDataSource.getSettings { result in
            switch result {
            case .success:
                print(SettingsDataSource.configutation)
                print(SettingsDataSource.configutation.images.baseUrl)
                print(SettingsDataSource.genres)
                print(SettingsDataSource.genres.first(where: { $0.id == 37 })!)
            case .failure(let error):
                print(error)
            }
        }
    }
}
