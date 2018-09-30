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
    
    private var movie: Movie?

    // MARK: - UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        movie = nil
    }
    
    // MARK: - Configure Methods
    
    func configure(withMovie movie: Movie) {
        self.movie = movie
        configureUI()
        configureConstraints()
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
        guard let movie = movie else {
            return
        }
        
        let posterPath = movie.posterPath ?? ""
        let posterSize = SettingsDataSource.configutation.images.posterSizeValue(.w780)
        let baseUrl = SettingsDataSource.configutation.images.baseUrl
        let path = baseUrl + posterSize + posterPath
        
        let imageTransition = ImageTransition.fade(0.5)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: path),
                              placeholder: UIImage(named: "poster_placeholder"),
                              options: [.transition(imageTransition)])
    }
    
    func cancelDownloadTask() {
        imageView.kf.cancelDownloadTask()
    }
}
