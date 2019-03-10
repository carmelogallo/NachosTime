//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import UIKit
import Kingfisher

class MovieImageSectionViewCell: UICollectionViewCell {

    // MARK: - UI objects

    private var imageView = UIImageView(frame: .zero)
    private var gradientLayer = CAGradientLayer()
    private var nameLabel = UILabel(frame: .zero)

    // MARK: - Business logic

    private var sectionInfo: MovieImageSection.Info!

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
        nameLabel.text = nil

        // Business logic
        sectionInfo = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // gradientLayer
        gradientLayer.frame = CGRect(x: 0.0, y: bounds.height / 2, width: bounds.width, height: bounds.height)
    }

    // MARK: - Configure methods

    func configure(sectionInfo: MovieImageSection.Info) {
        self.sectionInfo = sectionInfo
        nameLabel.text = sectionInfo.text
    }

    private func configureUI() {
        // imageView
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)

        // gradientLayer
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        imageView.layer.insertSublayer(gradientLayer, at: 0)

        // nameLabel
        nameLabel.accessibilityIdentifier = "InfoImageViewCell.Name"
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
    }

    private func configureConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            // imageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // nameLabel
            nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Picture Downloading Methods

    func starDownloadTask() {
        guard let sectionInfo = sectionInfo else {
            return
        }

        guard let baseUrl = Manager.dataSource.settings.configuration?.images.baseUrl,
              let imageSize = Manager.dataSource.settings.configuration?.images.posterSizeValue(.w342),
              let imagePath = sectionInfo.imagePath else {
            return
        }

        let path = baseUrl + imageSize + imagePath

        let imageTransition = ImageTransition.fade(0.5)
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        imageView.kf.setImage(with: URL(string: path), options: [.transition(imageTransition)])
    }

    func cancelDownloadTask() {
        imageView.kf.cancelDownloadTask()
    }

}
