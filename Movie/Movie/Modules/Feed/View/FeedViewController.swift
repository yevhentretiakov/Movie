//
//  ListViewController.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit
import Network

final class FeedViewController: UIViewController {
    // MARK: - Properties
    var presenter: FeedPresenter!
    var loadingView: UIView?
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var sortActionSheet: UIAlertController = {
        let alert = UIAlertController(title: "Sort Movies", message: "Please select an option", preferredStyle: .actionSheet)
        
        // Create default action
        let defaultAction = UIAlertAction(title: "Popular", style: .default) { action in
            self.selectSortType(.popular, with: action, alert: alert)
        }
        defaultAction.isEnabled = false
        defaultAction.setValue(true, forKey: "checked")
        
        // Add actions
        alert.addAction(UIAlertAction(title: "Now Playing", style: .default) { action in
            self.selectSortType(.playing, with: action, alert: alert)
        })
        alert.addAction(defaultAction)
        alert.addAction(UIAlertAction(title: "Top Rated", style: .default) { action in
            self.selectSortType(.topRated, with: action, alert: alert)
        })
        alert.addAction(UIAlertAction(title: "Upcoming", style: .default) { action in
            self.selectSortType(.upcoming, with: action, alert: alert)
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
    
    private func selectSortType(_ type: MoviesSortType, with action: UIAlertAction, alert: UIAlertController) {
        self.presenter.selectSortType(type)
        self.setActive(action: action, in: alert)
    }
    
    private func setActive(action: UIAlertAction, in alertController: UIAlertController) {
        alertController.actions.forEach { action in
            action.isEnabled = true
            action.setValue(false, forKey: "checked")
        }
        action.isEnabled = false
        action.setValue(true, forKey: "checked")
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
    
    func scrollToTop() {
        self.moviesTableView.setContentOffset(.zero, animated: false)
    }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.movieTapped(with: indexPath.row)
        moviesTableView.deselectRow(at: indexPath, animated: true)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.getItemsCount() - 1 {
            presenter.loadMore()
        }
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

