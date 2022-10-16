//
//  FavoriteDogListContracts.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

//MARK: - FavoriteDogListViewModelProtocol
protocol FavoriteDogListViewModelProtocol {
  var delegate: FavoriteDogListViewModelDelegate? { get set }
  func load() -> [String]
}

//MARK: - FavoriteDogListViewModelOutput
enum FavoriteDogListViewModelOutput: Equatable {
  case setTitle(String)
  case setLoading(Bool)
  case showFavorites(BreedImages)
  case showError(Error)
}

//MARK; - FavoriteDogListViewModelDelegate
protocol FavoriteDogListViewModelDelegate: AnyObject {
  func handleViewModelOutput(_ output: FavoriteDogListViewModelOutput)
  func notifyTableView()
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
