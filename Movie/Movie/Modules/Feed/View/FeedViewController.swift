//
//  ListViewController.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit

final class FeedViewController: UIViewController {
    // MARK: - Properties
    var presenter: FeedPresenter!
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutMoviesTableView()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupViewController()
        setupNavigationBar()
        setupMoviesTableView()
    }
    
    private func setupNavigationBar() {
        title = "Popular Movies"
    }
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupMoviesTableView() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        MovieTableViewCell.registerNib(in: moviesTableView)
        moviesTableView.rowHeight = 200
    }
    
    // MARK: - Layout Methods
    private func layoutMoviesTableView() {
        view.addSubview(moviesTableView)
        moviesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moviesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

// MARK: - FeedView
extension FeedViewController: FeedView {
    func reloadData() {
        moviesTableView.reloadData()
    }
    
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieTableViewCell.cell(in: moviesTableView, at: indexPath)
        let item = presenter.getItem(at: indexPath.row)
        cell.configure(with: item)
        return cell
    }
}
