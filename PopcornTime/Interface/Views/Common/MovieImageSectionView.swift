//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import UIKit

class MovieImageSectionView: UIView {

    // MARK: - UI objects

    private let titleLabel = UILabel()
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    // MARK: - Business logic

    private let reuseIdentifier = "MovieInfoViewCell"
    private let imageSection: MovieImageSection

    // MARK: - Object lifecycle

    required init(section: MovieImageSection) {
        self.imageSection = section
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        // self
        alpha = 0.0
        // titleLabel
        titleLabel.accessibilityIdentifier = "CreditsView.Title"
        titleLabel.text = imageSection.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)

        // collectionView
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieImageSectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addSubview(collectionView)
    }

    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            // collectionView
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 16 * 9),
        ]

        NSLayoutConstraint.activate(constraints)
    }

}

// MARK: - UICollectionViewDataSource

extension MovieImageSectionView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSection.info.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MovieImageSectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return UICollectionViewCell()
        }

        let sectionInfo = imageSection.info[indexPath.item]
        cell.configure(sectionInfo: sectionInfo)

        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension MovieImageSectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let movie = movies[indexPath.row]
//        let vc = MovieDetailsViewController(withMovie: movie)
//        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MovieImageSectionViewCell else {
            return
        }

        cell.starDownloadTask()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MovieImageSectionViewCell else {
            return
        }

        cell.cancelDownloadTask()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieImageSectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // we display the cell with a 16/9 aspect ratio in base of the height
        let height = collectionView.bounds.height
        let width: CGFloat = floor(height * 9 / 16)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
