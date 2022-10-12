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

typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Child>

final class MainViewController: UIViewController {

  //MARK: - Declare CollectionView
  private var collectionView: UICollectionView!

  //MARK: -  CollectionView Data Source
  private var dataSource: DataSource!
  private var searchController: UISearchController!

  //a searchText property the will be a 'Publisher'
  //that emits changes from the searchBar on the search controller
  //to subscribe to the searchText's 'Publisher' a $ needs to be prefixed
  //to searchText => $searchText
  @Published private var searchText = "cat"

  //store subscriptions
  private var subscriptions: Set<AnyCancellable> = []
  private var noSearchResultLabel = UILabel()
  private var photos: [Child] = []

  var viewModel: MainViewModelProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }

  lazy var activityIndicator: UIActivityIndicatorView = {
    return createActivityIndicator()
  }()

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Photos"
    setupNavigationBar()
    configureCollectionView()
    configureCollectionViewDataSource()
    configureSearchController()

    //subscribe to the searchText 'Publisher'
    $searchText
      .debounce(for: .seconds(1.0), scheduler: RunLoop.main)//Publishes elements only after a time interval elapses between events.
      .removeDuplicates()
      .sink { [weak self] (text) in //.assign
        self?.viewModel.load(query: text)
        //call the api client for the photo search queue
      }
      .store(in: &subscriptions)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    view.backgroundColor = .systemBackground

    if #available(iOS 11.0, *) {
      navigationItem.hidesSearchBarWhenScrolling = false
    }
    self.collectionView.reloadData()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if #available(iOS 11.0, *) {
      navigationItem.hidesSearchBarWhenScrolling = true
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    viewModel.viewWillDisappear()
  }

  private func showNoSearchResultLabel() {
    self.noSearchResultLabel.translatesAutoresizingMaskIntoConstraints = false
    self.noSearchResultLabel.textAlignment = .center
    self.noSearchResultLabel.font = .boldSystemFont(ofSize: 22)
    self.noSearchResultLabel.textColor = .systemTeal
    self.collectionView.isHidden = true
    self.noSearchResultLabel.text = "No search result!"
    self.view.addSubview(self.noSearchResultLabel)
    self.noSearchResultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.noSearchResultLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
  }

  private func configureSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self // delegate
    searchController.searchBar.delegate = self
    searchController.searchBar.autocapitalizationType = .none
    searchController.obscuresBackgroundDuringPresentation = false
  }

  // MARK: - NavigationBar
  private func setupNavigationBar() {
    title = "Photos"
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

  private func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
    collectionView.backgroundColor = .systemBackground
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.delegate = self
    view.addSubview(collectionView)
  }

  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      // item
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let itemSpacing: CGFloat = 5 // points
      item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)

      // group (leadingGroup, trailingGroup, nestedGroup)
      let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(1.0))
      let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 2)
      let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 3)
      let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1000))
      let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, trailingGroup])

      // section
      let section = NSCollectionLayoutSection(group: nestedGroup)
      return section
    }
    // layout
    return layout
  }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
    self.collectionView.isHidden = !self.collectionView.isHidden
    self.photos.removeAll()
    self.noSearchResultLabel.text = ""
    viewModel.searchBarCancelButtonClicked()
  }
}

//MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text,
          !text.isEmpty else {
      return
    }
    searchText = text
  }
}

//MARK: - UICollectionViewDataSource
extension MainViewController {
  private func configureCollectionViewDataSource() {
    //initializing the data source and
    //configuring the cell
    dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, photo) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else {
        fatalError("MainCollectionViewCell not found")
      }
      cell.configure(with: photo)
      cell.imageView.contentMode = .scaleAspectFill
      cell.backgroundColor = .systemBackground
      return cell
    })

    var snapshot = dataSource.snapshot() //current snapshot
    snapshot.appendSections([.main])
    dataSource.apply(snapshot, animatingDifferences: false)
    viewModel.delegate?.notifyCollectionView()
  }

  //MARK: - Snapshot
  private func updateSnapshot(with photos: [Child]) {
    var snapshot = dataSource.snapshot()
    snapshot.deleteAllItems()
    snapshot.appendSections([.main])
    snapshot.appendItems(photos)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    viewModel.selectPhoto(at: indexPath.row)
  }
}

//MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
  func handleViewModelOutput(_ output: MainViewModelOutput) {
    switch output {
    case .setTitle(let title):
      navigationItem.title = title
    case .setLoading(let isLoading):
      isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    case .showPhotos(let photos):
      updateSnapshot(with: photos)
      if photos.count > 0 { viewModel.isSearching = false } else { viewModel.isSearching = true }
    case .showError(_):
      self.collectionView.isHidden = !self.collectionView.isHidden
      self.showNoSearchResultLabel()
    }
  }

  func navigate(to route: MainViewRoute) {
    switch route {
    case .detail(let viewModel):
      let vc = MainDetailViewControllerBuilder.make(with: viewModel)
      navigationController?.pushViewController(vc, animated: false)
    }
  }

  func notifyCollectionView() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
}

