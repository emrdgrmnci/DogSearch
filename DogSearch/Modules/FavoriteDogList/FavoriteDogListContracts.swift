//
//  FavoriteDogListContracts.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import UIKit.UIImage
import Combine

//Things should send from View to ViewModel
//MARK: - FavoriteDogListViewModelProtocol
protocol FavoriteDogListViewModelProtocol {
  var searchResultsPublisher: Published<[String]>.Publisher { get }
  var delegate: FavoriteDogListViewModelDelegate? { get set }
  func load()
  func searchTextManipulation(searchText: String)
  func searchBarCancelButtonClicked()
  func updateSearchResult(text: String?)
  func checkFavoriteImage()
}

//MARK: - FavoriteDogListViewModelOutput
enum FavoriteDogListViewModelOutput: Equatable {
  case setTitle(String)
  case setLoading(Bool)
  case showFavorites(FavoriteDogListPresentation)
  case showError(Error)
}

//MARK; - FavoriteDogListViewModelDelegate
protocol FavoriteDogListViewModelDelegate: AnyObject {
  func handleViewModelOutput(_ output: FavoriteDogListViewModelOutput)
  func notifyTableView()
  func isTableView(hidden: Bool)
  func isShowNoFavoriteLabel(hidden: Bool)
}

//MARK: - FavoriteDogListViewModelOutput
extension FavoriteDogListViewModelOutput {
  static func == (lhs: FavoriteDogListViewModelOutput, rhs: FavoriteDogListViewModelOutput) -> Bool {
    switch (lhs, rhs) {
    case (.setTitle(let a), .setTitle(let b)):
      return a == b
    case (.setLoading(let a), .setLoading(let b)):
      return a == b
    case (.showFavorites(let a), .showFavorites(let b)):
      return a == b
    default:
      return false
    }
  }
}
