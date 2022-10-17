//
//  MainViewController.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit
import Combine

enum SectionKind: Int, CaseIterable {
  case main
}

final class FavoriteDogListViewController: UIViewController {
  
  //MARK: - Variables
  private var tableView =  UITableView()
  private var breedImages: BreedImages = .init(message: [], status: "")
  private var favoriteImagesFromFileManager = [UIImage]()
  private var readAllFilesFromFileManager = [String]()
  
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
    
    // Read Favorite images from FileManager
    do {
      readAllFilesFromFileManager = try FileStorageManager.shared.readAllFiles() ?? [""]
      for file in readAllFilesFromFileManager {
        try favoriteImagesFromFileManager.append(FileStorageManager.shared.read(fileNamed: file) ?? UIImage())
      }
    } catch { }
    
    setupNavigationBar()
    configureTableView()
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
    tableView.register(FavoriteDogListTableViewCell.self, forCellReuseIdentifier: FavoriteDogListTableViewCell.reuseIdentifier)
    setTableViewDelegates()
    tableView.allowsSelection = false
    tableView.rowHeight = 100
  }
  
  //MARK: -  Set TableView Delegates
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
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.sizeToFit()
  }
}

// MARK: - UITableViewDataSource
extension FavoriteDogListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteImagesFromFileManager.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteDogListTableViewCell.reuseIdentifier, for: indexPath) as? FavoriteDogListTableViewCell else {
      fatalError("FavoriteDogListTableViewCell not found")
    }
    
    let favImage = self.favoriteImagesFromFileManager[indexPath.row]
    cell.index = indexPath
    
    if favoriteImagesFromFileManager.count != 0 {
      cell.favoriteImageView.image = favImage
    }
    
    do {
      cell.breedLabel.text = try FileStorageManager.shared.getBreedByFilePath(fileNamed: readAllFilesFromFileManager[indexPath.row])
    } catch {}
    return cell
  }
}

// MARK: - UITableViewDelegate
extension FavoriteDogListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
}

//MARK: - MainViewModelDelegate
extension FavoriteDogListViewController: FavoriteDogListViewModelDelegate{
  func handleViewModelOutput(_ output: FavoriteDogListViewModelOutput) {
    switch output {
    case .setTitle(let title):
      navigationItem.title = title
    case .setLoading(let isLoading):
      isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    case .showFavorites(let dogBreed):
      self.breedImages = dogBreed
      notifyTableView()
    case .showError(_):
      break
    }
  }
  
  //MARK: - Notify Favorites TableView
  func notifyTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
