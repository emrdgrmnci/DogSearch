//
//  BreedListDetailViewController.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit
import Combine

final class BreedListDetailViewController: UIViewController {
  
  //MARK: - Variables
  private var tableView =  UITableView()
  
  private var breeds: DogBreed = .init(message: [:], status: "")
  private var breedImages: BreedImages = .init(message: [], status: "")
  
  var detailViewModel: BreedListDetailViewModelProtocol!

  private var cancellable: AnyCancellable?
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    return createActivityIndicator()
  }()
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    detailViewModel.delegate = self
    detailViewModel.load()
    
    setupNavigationBar()
    configureTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    view.backgroundColor = .systemBackground
    
    if #available(iOS 11.0, *) {
      navigationItem.hidesSearchBarWhenScrolling = false
    }
    self.tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if #available(iOS 11.0, *) {
      navigationItem.hidesSearchBarWhenScrolling = true
    }
  }

  //MARK: - Configure TableView
  private func configureTableView() {
    view.addSubview(tableView)
    tableView.register(BreedListDetailTableViewCell.self, forCellReuseIdentifier: BreedListDetailTableViewCell.reuseIdentifier)
    setTableViewDelegates()
    tableView.allowsSelection = false
    tableView.rowHeight = 100
  }

  //MARK: -  Set TableView Delegates
  private func setTableViewDelegates() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - Setup NavigationBar
  private func setupNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground
    appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                      .foregroundColor: UIColor.tintColor]
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.sizeToFit()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(goToFavorites))
  }

  //MARK: - Go to Favorites
  @objc func goToFavorites() {
    let vc = FavoriteDogListViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension BreedListDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.breedImages.message.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedListDetailTableViewCell.reuseIdentifier, for: indexPath) as? BreedListDetailTableViewCell else {
      fatalError("BreedListDetailTableViewCell not found")
    }
    
    cell.index = indexPath

    cell.cancellable = cell.tapButton.compactMap{$0} .sink { [weak self] selectedIndex in
      DispatchQueue.main.async {
        self?.detailViewModel.selectBreed(at: selectedIndex.row, imagePath: self?.breedImages.message ?? [""])
      }
    }
    cell.configure(with: self.breedImages, indexPath: indexPath)
    return cell
  }
}
// MARK: - UITableViewDelegate
extension BreedListDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
}

//MARK: - MainViewModelDelegate
extension BreedListDetailViewController: BreedListDetailViewModelDelegate {
  func handleViewModelOutput(_ output: BreedListDetailViewModelOutput) {
    switch output {
    case .setTitle(let title):
      navigationItem.title = title
    case .setLoading(let isLoading):
      isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    case .showFavoriteImages(let favImages):
      self.breedImages = favImages
      self.notifyTableView()
    case .showError(_):
      break
    }
  }
  
  func navigate(to route: BreedListDetailViewRoute) {
    switch route {
    case .detail(let viewModel):
      let vc = FavoriteDogListViewController()
      vc.viewModel = viewModel
      navigationController?.pushViewController(vc, animated: false)
    }
  }
  
  func notifyTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func selectBreed(at index: Int, breedQuery: String) {
    
  }
  
  func showDetail(_ presentation: BreedListDetailPresentation) {
    self.breedImages.message = presentation.breedImages
  }
}
