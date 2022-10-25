//
//  BreedListViewController.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import UIKit
import Combine

final class BreedListViewController: UIViewController {
  
  //MARK: - Variables
  private var tableView =  UITableView()
  private var breeds: DogBreed = .init(message: [:], status: "")
  private var breedImages: BreedImages = .init(message: [], status: "")
  //store subscriptions
  private var subscriptions: Set<AnyCancellable> = []
  
  var viewModel: BreedListViewModelProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }
  
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
    viewModel.load()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.backgroundColor = .systemBackground
    setupNavigationBar()
    self.tableView.reloadData()
  }
  
  //MARK: - Configure TableView
  private func configureTableView() {
    view.addSubview(tableView)
    tableView.register(BreedListTableViewCell.self, forCellReuseIdentifier: BreedListTableViewCell.reuseIdentifier)
    setTableViewDelegates()
    tableView.rowHeight = 100
  }
  
  //MARK: -  Set TableView Delegates
  private func setTableViewDelegates() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - NavigationBar
  private func setupNavigationBar() {
    title = "Dog Breeds 🐶"
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground
    appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                      .foregroundColor: UIColor.tintColor]
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.sizeToFit()
  }
}

// MARK: - UITableViewDataSource
extension BreedListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return breeds.message.values.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedListTableViewCell.reuseIdentifier, for: indexPath) as? BreedListTableViewCell else {
      fatalError("BreedListTableViewCell not found")
    }
    
    let breedKeys = breeds.message.keys.sorted(by: <)
    cell.configure(with: breedKeys[indexPath.row].capitalized)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension BreedListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  // MARK: - Routing
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.selectBreed(at: indexPath.row, breedQuery: breeds.message.keys.sorted(by: <)[indexPath.row])
  }
}

//MARK: - MainViewModelDelegate
extension BreedListViewController: BreedListViewModelDelegate{
  func handleViewModelOutput(_ output: BreedListViewModelOutput) {
    switch output {
    case .setTitle(let title):
      navigationItem.title = title
    case .setLoading(let isLoading):
      isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    case .showBreeds(let breeds):
      self.breeds = breeds
      self.notifyTableView()
    case .showBreedImages(let breedImages):
      self.breedImages = breedImages
      self.notifyTableView()
    case .showError(_):
      break
    }
  }
  
  func notifyTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func navigate(to route: BreedListViewRoute) {
    switch route {
    case .detail(let viewModel):
      let viewController = BreedListDetailViewControllerBuilder.make(with: viewModel, with: self.breedImages.message)
      navigationController?.pushViewController(viewController, animated: false)
    }
  }
}
