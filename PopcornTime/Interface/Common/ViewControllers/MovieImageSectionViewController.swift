//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol MovieImageSectionDisplayLogic: class {
    func displayImageSection(_ imageSection: MovieImageSection)
}

class MovieImageSectionViewController: UIViewController {

    // MARK: - UI objects

    private let titleLabel = UILabel()
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    // MARK: - Business logic

    private var interactor: MovieImageSectionBusinessLogic?
    private let reuseIdentifier = "MovieInfoViewCell"
    private let context: MovieImageSection.Context
    private let movieId: Int
    private let credits: Credits?
    private var imageSection: MovieImageSection?

    // MARK: - Object lifecycle

    // todo: do a better initialization
    required init(context: MovieImageSection.Context, movieId: Int, credits: Credits? = nil) {
        self.context = context
        self.movieId = movieId
        self.credits = credits
        super.init(nibName: nil, bundle: nil)
        configureLogic()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // configure
        configureUI()
        configureConstraints()
        // interactor
        // todo: remove force unwrap
        switch context {
        case .crew:
            interactor?.getCrewSection(credits!)
        case .cast:
            interactor?.getCastSection(credits!)
        case .similar:
            interactor?.getSimilar(of: movieId)
        }
    }

    // MARK: - Configure methods

    private func configureLogic() {
        let viewController = self
        let interactor = MovieImageSectionInteractor()
        viewController.interactor = interactor
        interactor.viewController = viewController
    }

    private func configureUI() {
        // view
        view.alpha = 0.0

        // titleLabel
        titleLabel.accessibilityIdentifier = "CreditsView.Title"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        // collectionView
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieImageSectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
    }

    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // collectionView
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.bounds.width / 4 * 3 * 0.7)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Internal methods

    func show() {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
}

// MARK: - MovieImageSectionDisplayLogic

extension MovieImageSectionViewController: MovieImageSectionDisplayLogic {

    func displayImageSection(_ imageSection: MovieImageSection) {
        self.imageSection = imageSection
        titleLabel.text = imageSection.title
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource

extension MovieImageSectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSection?.info.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MovieImageSectionViewCell else {
            assertionFailure("This shouldn't have happened!")
            return UICollectionViewCell()
        }

        if let sectionInfo = imageSection?.info[indexPath.item] {
            cell.configure(sectionInfo: sectionInfo)
        }

        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension MovieImageSectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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

extension MovieImageSectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // we display the cell with a 16/9 aspect ratio in base of the height
        let height = collectionView.bounds.height
        let width: CGFloat = floor(height * 3 / 4)
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

// MARK: - UIScrollViewDelegate

extension MovieImageSectionViewController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.width - (targetContentOffset.pointee.x + scrollView.bounds.width)
        guard distance < scrollView.bounds.width else { return }

    }
}
