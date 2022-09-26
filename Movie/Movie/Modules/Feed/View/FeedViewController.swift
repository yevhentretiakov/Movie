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
    
    private lazy var sortActionSheet: UIAlertController = {
        let alert = UIAlertController(title: "Sort Movies", message: "Please select an option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Now Playing", style: .default) { action in
            self.presenter.selectSortType(.playing)
        })
        alert.addAction(UIAlertAction(title: "Popular", style: .default) { action in
            self.presenter.selectSortType(.popular)
        })
        alert.addAction(UIAlertAction(title: "Top Rated", style: .default) { action in
            self.presenter.selectSortType(.topRated)
        })
        alert.addAction(UIAlertAction(title: "Upcoming", style: .default) { action in
            self.presenter.selectSortType(.upcoming)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        return alert
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.autocapitalizationType = .none
        return searchController
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
        setupSortButton()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
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
        moviesTableView.rowHeight = 250
    }
    
    private func setupSortButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSortButton))
    }
    
    @objc private func didTapSortButton() {
        self.present(sortActionSheet, animated: true)
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
    
    func showLoadingIndicator() {
        showLoadingView()
    }
    
    func hideLoadingIndicator() {
        hideLoadingView()
    }
    
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.moviesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.movieTapped(with: indexPath.row)
        moviesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = moviesTableView.contentOffset.y
        let contentHeight = moviesTableView.contentSize.height
        let height = moviesTableView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter.loadMore()
        }
    }
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

// MARK: - UISearchBarDelegate
extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.cancelSearch()
    }
}
