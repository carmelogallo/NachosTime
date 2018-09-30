//
//  NowPlayingCollectionViewCell.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 30/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Configure Methods
    
    func configure() {
        configureUI()
        configureConstraints()
    }
    
    private func configureUI() {
        // contentView
        contentView.backgroundColor = .yellow
    }
    
    private func configureConstraints() {
        // collectionView
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//            ])
    }
}
