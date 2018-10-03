//
//  MovieDetailsViewController.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {

    // MARK: - UI Objects
    
    private let scrollView = UIScrollView(frame: .zero)
    private let contentView = UIView(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let genresLabel = UILabel(frame: .zero)
    private let overviewLabel = UILabel(frame: .zero)

    // MARK: - Business Logic Objects
    
    private let movie: Movie
    
    // MARK: - Object Lifecycle
    
    required init(withMovie movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        loadBackdropImage()
    }
    
    // MARK: - Configure Methods
    
    private func configureViews() {
        configureObjects()
        configureConstraints()
    }
    
    private func configureObjects() {
        // navigationController
        title = "Movie Details"
        navigationItem.largeTitleDisplayMode = .never

        // view
        view.backgroundColor = .black
        
        // scrollView
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        // contentView
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        
        // imageView
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        // titleLabel
        titleLabel.text = movie.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        // genresLabel
        genresLabel.text = movie.genres
        genresLabel.font = UIFont.boldSystemFont(ofSize: 12)
        genresLabel.textColor = .white
        genresLabel.numberOfLines = 0
        contentView.addSubview(genresLabel)
        
        // overviewLabel
        overviewLabel.text = movie.overview
        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        contentView.addSubview(overviewLabel)
    }
    
    private func configureConstraints() {
        // scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

        // contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewHeight = view.bounds.width / 16 * 9
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight)
            ])
        
        // titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
        
        // genresLabel
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
        
        // overviewLabel
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 8),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
    }
    
    // MARK: - Picture Downloading Methods
    
    private func loadBackdropImage() {
        guard let baseUrl = DataSource.settings.configutation?.images.baseUrl,
            let backdropSize = DataSource.settings.configutation?.images.backdropSizeValue(.w780) else {
                return
        }

        let backdropPath = movie.backdropPath ?? ""
        let path = baseUrl + backdropSize + backdropPath
        
        let imageTransition = ImageTransition.fade(0.5)
        imageView.kf.setImage(with: URL(string: path),
                              placeholder: UIImage(named: "backdrop_placeholder"),
                              options: [.transition(imageTransition)])
    }

}
