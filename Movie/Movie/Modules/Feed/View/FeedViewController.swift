//
//  ListViewController.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit
import netfox

final class FeedViewController: UIViewController {
    // MARK: - Properties
    var presenter: FeedPresenter!
    private var loadingView: UIView?
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 250
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private lazy var sortActionSheet: UIAlertController = {
        let alert = UIAlertController(title: "Sort Movies",
                                      message: "Please select an option",
                                      preferredStyle: .actionSheet)
        
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

    private lazy var nothingFoundView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "NothingFound")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 140).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let label = UILabel()
        label.text = "Nothing found :("
        
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
        stackView.isHidden = true
        return stackView
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
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
    
    private func selectSortType(_ type: MoviesSortType,
                                with action: UIAlertAction,
                                alert: UIAlertController) {
        self.presenter.selectSortType(type)
        self.setActive(action: action, in: alert)
    }
    
    private func setActive(action: UIAlertAction,
                           in alertController: UIAlertController) {
        alertController.actions.forEach { action in
            action.isEnabled = true
            action.setValue(false, forKey: "checked")
        }
        action.isEnabled = false
        action.setValue(true, forKey: "checked")
    }
    
    private func setNothingFoundState() {
        if presenter.getItemsCount() == 0 {
            nothingFoundView.isHidden = false
        } else {
            nothingFoundView.isHidden = true
        }
    }
    
    // MARK: - Layout Methods
    private func layout() {
        layoutMoviesTableView()
        layoutNothingFound()
    }
    
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
    
    private func layoutNothingFound() {
        view.addSubview(nothingFoundView)
        nothingFoundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nothingFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingFoundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        ])
    }
}

// MARK: - FeedView
extension FeedViewController: FeedView {
    func reloadData() {
        moviesTableView.reloadData()
        setNothingFoundState()
    }
    
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func scrollToTop() {
        moviesTableView.setContentOffset(.zero, animated: false)
    }
    
    func hideSortButton() {
        navigationItem.rightBarButtonItem = nil
    }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showMovieDetails(with: indexPath.row)
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
        if let item = presenter.getItem(at: indexPath.row) {
            cell.configure(with: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.getItemsCount() - 1 {
            presenter.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if presenter.isSearching(),
           presenter.getItemsCount() > 0 {
            let headerView = UIView.init(frame: .zero)
            headerView.backgroundColor = .systemGray4
            let label = UILabel()
            label.text = "Showing \(presenter.getItemsCount()) of \(presenter.getTotalItemsCount())"
            label.textColor = .label
            headerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])
            return headerView
        } else {
            return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if presenter.isSearching(),
           presenter.getItemsCount() > 0 {
            return 40
        } else {
            return 0
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

