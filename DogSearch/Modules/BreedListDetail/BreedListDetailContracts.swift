//
//  BreedListDetailContracts.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

//MARK: - BreedListDetailViewModelProtocol
protocol BreedListDetailViewModelProtocol: AnyObject {
  var delegate: BreedListDetailViewModelDelegate? { get set }
  func load()
  func selectBreed(at index: Int, imagePath: [String])
  func goToFavorite()
}

//MARK: - BreedListDetailViewModelOutput
enum BreedListDetailViewModelOutput: Equatable {
  case setTitle(String)
  case setLoading(Bool)
  case showFavoriteImages(BreedImages)
  case showError(Error)
}

//MARK: - BreedListDetailVieRoute to Favorite
enum BreedListDetailViewRoute {
  case detail(FavoriteDogListViewModelProtocol)
}

//MARK: - BreedListDetailed data presentation (View is delegate)
protocol BreedListDetailViewModelDelegate: AnyObject {
  func showDetail(_ presentation: BreedListDetailPresentation)
  func navigate(to route: BreedListDetailViewRoute)
  func notifyTableView()
}

//MARK: - BreedListDetailViewModelOutput
extension BreedListDetailViewModelOutput {
  static func == (lhs: BreedListDetailViewModelOutput, rhs: BreedListDetailViewModelOutput) -> Bool {
    switch (lhs, rhs) {
    case (.setTitle(let a), .setTitle(let b)):
      return a == b
    case (.setLoading(let a), .setLoading(let b)):
      return a == b
    case (.showFavoriteImages(let a), .showFavoriteImages(let b)):
      return a == b
    default:
      return false
    }
  }
}
