//
//  NowPlayingCollectionViewCell.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit
import Kingfisher

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Objects
    
    private var imageView = UIImageView(frame: .zero)
    
    // MARK: - Business Logic Objects
    
    private var movie: Movie!

    // MARK: - Object lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()

        // UI objects
        imageView.image = nil

        // Business logic
        movie = nil
    }
    
    // MARK: - Configure Methods
    
    func configure(movie: Movie) {
        self.movie = movie
    }
    
    private func configureUI() {
        // contentView
        contentView.backgroundColor = .clear
        
        // imageView
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    private func configureConstraints() {
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
    }
    
    // MARK: - Picture Downloading Methods
    
    func starDownloadTask() {
        guard let baseUrl = Manager.dataSource.settings.configuration?.images.baseUrl,
              let posterSize = Manager.dataSource.settings.configuration?.images.posterSizeValue(.w780),
              let posterPath = movie.posterPath else {
            return
        }

        let path = baseUrl + posterSize + posterPath

        let imageTransition = ImageTransition.fade(0.5)
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        imageView.kf.setImage(with: URL(string: path), options: [.transition(imageTransition)])
    }
    
    func cancelDownloadTask() {
        imageView.kf.cancelDownloadTask()
    }
}
