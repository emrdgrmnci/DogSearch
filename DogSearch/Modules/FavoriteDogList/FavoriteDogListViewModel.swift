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
  }
  
  private func findItems(searchText: String) -> [String] {
    searchResults = self.favoriteImagesFromFileManager.filter { $0.lowercased().contains( searchText.lowercased()) }
    return searchResults
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
  }
  
  private func notify(_ output: FavoriteDogListViewModelOutput) -> [String] {
    delegate?.handleViewModelOutput(output)
    return favoriteImagesFromFileManager
  }
  
  func searchTextManipulation(searchText : String) {
    $searchText
      .debounce(for: .seconds(1.0), scheduler: RunLoop.main)//Publishes elements only after a time interval elapses between events.
      .removeDuplicates()
      .sink { [weak self] (_) in //.assign
        
        if self?.searchResults == []  {
          self?.delegate?.isTableView(hidden: true)
          self?.delegate?.isShowNoFavoriteLabel(hidden: false)
          self?.searchResults.removeAll()
        } else {
          self?.searchArray.forEach {
            self?.searchResults.append($0)
          }
          self?.delegate?.isTableView(hidden: false)
          self?.delegate?.isShowNoFavoriteLabel(hidden: true)
          self?.delegate?.notifyTableView()
        }
      }
      .store(in: &subscriptions)
  }
  
  func searchBarCancelButtonClicked() {
    self.favoriteImagesFromFileManager = self.notify(.showFavorites(self.presentations))
    delegate?.notifyTableView()
  }
}
