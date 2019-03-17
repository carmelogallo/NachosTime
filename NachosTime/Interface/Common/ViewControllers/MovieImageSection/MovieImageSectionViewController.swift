//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import UIKit

protocol MovieImageSectionDisplayLogic: class {
    func displaySection()
    func insertNewItems(at indexPaths: [IndexPath], completion: @escaping (() -> Void))
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

    private var viewModel: MovieImageSectionBusinessLogic

    // MARK: - Object lifecycle

    required init(viewModel: MovieImageSectionBusinessLogic) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewController = self
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
        // load section
        viewModel.loadSection()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }

    // MARK: - Configure methods

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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        collectionView.alwaysBounceHorizontal = true
        viewModel.registerCell(in: collectionView)
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
            collectionView.heightAnchor.constraint(equalToConstant: viewModel.collectionViewHeightDelta(in: view))
        ]

        NSLayoutConstraint.activate(constraints)
    }

}

// MARK: - MovieImageSectionDisplayLogic

extension MovieImageSectionViewController: MovieImageSectionDisplayLogic {

    func displaySection() {
        // titleLabel
        titleLabel.text = viewModel.title

        // collectionView
        collectionView.reloadData()
    }

    func insertNewItems(at indexPaths: [IndexPath], completion: @escaping (() -> Void)) {
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
        }, completion: { success in
            completion()
        })
    }

}

// MARK: - UICollectionViewDataSource

extension MovieImageSectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.cell(at: indexPath, in: collectionView)
    }

}

// MARK: - UICollectionViewDelegate

extension MovieImageSectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.starDownloadTask(in: cell)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.cancelDownloadTask(in: cell)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieImageSectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItem(at: indexPath, in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSection
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSection
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSection
    }

}

// MARK: - UIScrollViewDelegate

extension MovieImageSectionViewController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        viewModel.loadNextItemsIfNeeded(in: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
