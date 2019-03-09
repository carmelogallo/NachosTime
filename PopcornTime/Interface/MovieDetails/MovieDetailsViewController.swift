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
    private let backdropImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let voteLabel = UILabel(frame: .zero)
    private let starImageView = UIImageView(image: UIImage(named: "star"))
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
        configureUI()
        configureConstraints()
    }
    
    private func configureUI() {
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
        backdropImageView.backgroundColor = .clear
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        contentView.addSubview(backdropImageView)
        
        // titleLabel
        titleLabel.accessibilityIdentifier = "MovieDetails.Movie.Title"
        titleLabel.text = movie.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)

        // voteLabel
        voteLabel.accessibilityIdentifier = "MovieDetails.Movie.Vote"
        voteLabel.text = String(movie.voteAverage)
        voteLabel.font = UIFont.systemFont(ofSize: 16)
        voteLabel.textColor = .white
        contentView.addSubview(voteLabel)

        // starImageView
        starImageView.backgroundColor = .clear
        contentView.addSubview(starImageView)

        // genresLabel
        genresLabel.accessibilityIdentifier = "MovieDetails.Movie.Genres"
        genresLabel.text = movie.genres
        genresLabel.font = UIFont.boldSystemFont(ofSize: 12)
        genresLabel.textColor = .white
        genresLabel.numberOfLines = 0
        contentView.addSubview(genresLabel)
        
        // overviewLabel
        overviewLabel.accessibilityIdentifier = "MovieDetails.Movie.Overview"
        overviewLabel.text = movie.overview
        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        contentView.addSubview(overviewLabel)
    }
    
    private func configureConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        voteLabel.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // contentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // imageView
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 16 * 9),
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            // starImageView
            starImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            starImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            // voteLabel
            voteLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            voteLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 3),
            voteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            // genresLabel
            genresLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            // overviewLabel
            overviewLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 8),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Picture Downloading Methods
    
    private func loadBackdropImage() {
        guard let baseUrl = Manager.dataSource.settings.configuration?.images.baseUrl,
            let backdropSize = Manager.dataSource.settings.configuration?.images.backdropSizeValue(.w780) else {
                return
        }

        let backdropPath = movie.backdropPath ?? ""
        let path = baseUrl + backdropSize + backdropPath
        
        let imageTransition = ImageTransition.fade(0.5)
        backdropImageView.kf.setImage(with: URL(string: path),
                              placeholder: UIImage(named: "backdrop_placeholder"),
                              options: [.transition(imageTransition)])
    }

}
