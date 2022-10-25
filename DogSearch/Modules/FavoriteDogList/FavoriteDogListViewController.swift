//
//  MainViewController.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit
import Combine

final class FavoriteDogListViewController: UIViewController {
  
  //MARK: - Variables
  private var tableView =  UITableView()
  private var readAllFilesFromFileManager = [String]()
  private var showNoFavoriteLabel: UILabel!
  private var searchController: UISearchController!
  private var favList: FavoriteDogListPresentation?
  
  //a searchText property the will be a 'Publisher'
  //that emits changes from the searchBar on the search controller
  //to subscribe to the searchText's 'Publisher' a $ needs to be prefixed
  //to searchText => $searchText
  
  @Published var searchText: String?
  private var subscriptions: Set<AnyCancellable> = []
  var searchResultsSubscription : AnyCancellable! = nil
  
  @Published var searchResults = [String]()
  @Published var searchFinalResults = [String]()
  
  var viewModel: FavoriteDogListViewModelProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }
  
  private lazy var activityIndicator: UIActivityIndicatorView = {
    return createActivityIndicator()
  }()
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.load()
    setupNavigationBar()
    setupNoFavoriteLabel()
    checkFavoriteImage()
    configureTableView()
    
    searchResultsSubscription = viewModel.searchResultsPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.searchFinalResults, on: self)
    print("searchFinalResults", searchFinalResults)
    notifyTableView()
    configureSearchController()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.backgroundColor = .systemBackground
  }
  
  //MARK: - Configure TableView UI
  private func configureTableView() {
    view.addSubview(tableView)
    setTableViewDelegates()
    tableView.register(FavoriteDogListTableViewCell.self, forCellReuseIdentifier: FavoriteDogListTableViewCell.reuseIdentifier)
    tableView.allowsSelection = false
    tableView.rowHeight = 100
  }
  
  private func setTableViewDelegates() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - NavigationBar
  private func setupNavigationBar() {
    title = "Favorites"
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground
    appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                      .foregroundColor: UIColor.systemBackground]
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.sizeToFit()
  }
  
  //MARK: - Setup UI
  private func setupNoFavoriteLabel() {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
    ])
    
    showNoFavoriteLabel = UILabel()
    showNoFavoriteLabel.text = "There is no favorite image!"
    showNoFavoriteLabel.textAlignment = .center
    stackView.addArrangedSubview(showNoFavoriteLabel)
    NSLayoutConstraint.activate([
      showNoFavoriteLabel.heightAnchor.constraint(equalToConstant: 40),
      showNoFavoriteLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
    ])
  }
  
  private func configureSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self // delegate
    searchController.searchBar.delegate = self
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.placeholder = "Type at least 2 characters."
  }
  
  //MARK: - Check if there is a favorite image
  private func checkFavoriteImage() {
    //    viewModel.checkFavoriteImage()
  }
}
// MARK: - UITableViewDataSource
extension FavoriteDogListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !searchFinalResults.contains("") {
      self.searchResults = searchFinalResults
    }
    return searchResults.count == 0 ? favList?.favImages.count ?? 0 : searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteDogListTableViewCell.reuseIdentifier, for: indexPath) as? FavoriteDogListTableViewCell else {
      fatalError("FavoriteDogListTableViewCell not found")
    }
    
    if !searchFinalResults.contains("") {
      self.searchResults = searchFinalResults
    }
    
    let favImage = favList?.favImages
    cell.index = indexPath
    DispatchQueue.main.async {
      if self.searchResults.count == 0 {
        cell.configure(with: favImage ?? [""], indexPath: indexPath)
      } else {
        cell.configure(with: self.searchResults, indexPath: indexPath)
      }
    }
    return cell
  }
}

// MARK: - UISearchBarDelegate
extension FavoriteDogListViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
    viewModel.searchBarCancelButtonClicked()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print("searchText", searchText)
    viewModel.searchTextManipulation(searchText: searchText)
    notifyTableView()
  }
}

//MARK: - UISearchResultsUpdating
extension FavoriteDogListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    viewModel.updateSearchResult(text: searchController.searchBar.text)
    searchText = searchController.searchBar.text ?? ""
  }
}

// MARK: - UITableViewDelegate
extension FavoriteDogListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      do {
        let _ = try FileStorageManager.shared.removeFileFromFileManager(filePath: searchResults[indexPath.row])
        searchResults.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.reloadData()
        self.checkFavoriteImage()
      } catch { }
    }
  }
}

extension FavoriteDogListViewController: FavoriteDogListViewModelDelegate {
  func showFavorites(_ presentation: FavoriteDogListPresentation) {
    self.readAllFilesFromFileManager = presentation.favImages
  }
  
  func handleViewModelOutput(_ output: FavoriteDogListViewModelOutput) {
    switch output {
    case .setTitle(let title):
      navigationItem.title = title
    case .setLoading(let isLoading):
      isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    case .showFavorites(let favImages):
      self.favList = favImages
      notifyTableView()
    case .showError(_):
      self.tableView.isHidden = !self.tableView.isHidden
      self.setupNoFavoriteLabel()
    }
  }
  
  func notifyTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func isTableView(hidden: Bool) {
    if hidden == true {
      self.tableView.isHidden = true
    } else {
      self.tableView.isHidden = false
    }
  }
  
  func isShowNoFavoriteLabel(hidden: Bool) {
    if hidden == true {
      self.showNoFavoriteLabel.isHidden = true
    }  else {
      self.showNoFavoriteLabel.isHidden = false
    }
  }
}
