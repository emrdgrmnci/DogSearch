//
//  FavoriteDogListViewModel.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine
import UIKit.UIImage

final class FavoriteDogListViewModel {

  //MARK: - Variables
  weak var delegate: FavoriteDogListViewModelDelegate?

  private let fileManagerService = FileStorageManager()

  private var readAllFiles: [String] = [""]
  private var readAllFilesFromFileManager: [String] = [""]

  var searchArray = [String]()

  var subscriptions: Set<AnyCancellable> = []

  @Published var searchText = ""
  @Published var searchResults = [""]

  var subscription: AnyCancellable! = nil

  var favoriteImagesFromFileManager: [String] = [""]
  var presentations = FavoriteDogListPresentation(favimages: [""])

  init(favoriteImagesFromFileManager: [String]) {
    self.favoriteImagesFromFileManager = favoriteImagesFromFileManager
    self.subscription = $searchText
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .removeDuplicates()
      .map(findItems)
      .assign(to: \.searchResults, on: self)
    //    searchTextManipulation(searchText: searchText)
  }

  private func findItems(searchText: String) -> [String] {
    searchArray = self.favoriteImagesFromFileManager.filter { $0.lowercased().contains( searchText.lowercased()) }
    return searchArray
  }
}

extension FavoriteDogListViewModel: FavoriteDogListViewModelProtocol {
  var searchResultsPublisher: Published<[String]>.Publisher {
    $searchResults
  }

  func updateSearchResult(text: String?) {
    guard let text = text,
          !text.isEmpty else {
      return
    }
    searchText = text
  }

  //MARK: - Read Favorites from FileManager
  func load() {
    let _ = notify(.setTitle("Favorite"))
    let _ = notify(.setLoading(true))

    do { readAllFilesFromFileManager = try fileManagerService.readAllFiles() ?? [""] } catch { }

    let _ = notify(.setLoading(false))
    presentations = FavoriteDogListPresentation(favimages: readAllFilesFromFileManager)
    favoriteImagesFromFileManager = self.notify(.showFavorites(presentations))

    favoriteImagesFromFileManager.forEach {
      searchTextManipulation(searchText: $0)
    }
  }

  private func notify(_ output: FavoriteDogListViewModelOutput) -> [String] {
    delegate?.handleViewModelOutput(output)
    return favoriteImagesFromFileManager
  }

  func searchTextManipulation(searchText : String) {

    //subscribe to the searchText 'Publisher'
    $searchText
      .debounce(for: .seconds(1.0), scheduler: RunLoop.main)//Publishes elements only after a time interval elapses between events.
      .removeDuplicates()
      .sink { [weak self] (text) in //.assign
        self?.delegate?.isTableView(hidden: false)
        self?.delegate?.isShowNoFavoriteLabel(hidden: true)

        if self?.searchResults.count == 0 && text == "" {
            self?.checkFavoriteImage()
//            self?.delegate?.isTableView(hidden: true)
//            self?.delegate?.isShowNoFavoriteLabel(hidden: false)
          } else {
            self?.delegate?.isTableView(hidden: false)
            self?.delegate?.isShowNoFavoriteLabel(hidden: true)
            self?.searchResults.removeAll()
            self?.searchArray.forEach {
              self?.searchResults.append($0)
            }
          }
          self?.delegate?.notifyTableView()
      }
      .store(in: &subscriptions)
  }

  func searchBarCancelButtonClicked() {
    self.readAllFiles.removeAll()//Remove all photo objects
    self.favoriteImagesFromFileManager = self.notify(.showFavorites(self.presentations))
    delegate?.notifyTableView()
  }

  func checkFavoriteImage() {
    if readAllFilesFromFileManager.count == 0 || self.favoriteImagesFromFileManager.count == 0 {
      self.delegate?.isTableView(hidden: true)
    } else {
      self.delegate?.isTableView(hidden: false)
    }
  }
}
