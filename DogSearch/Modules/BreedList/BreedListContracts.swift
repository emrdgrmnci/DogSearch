//
//  BreedListContracts.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import Foundation
import Combine

//MARK: - BreedListViewModelProtocol
protocol BreedListViewModelProtocol {
  var delegate: BreedListViewModelDelegate? { get set }
  func load()
  func selectBreed(at index: Int, breedQuery: String)
}

//MARK: - BreedListViewModelOutput
enum BreedListViewModelOutput: Equatable {
  case setTitle(String)
  case setLoading(Bool)
  case showBreeds(DogBreed)
  case showBreedImages(BreedImages)
  case showError(Error)
}

//MARK: - BreedListViewRoute to Detail
enum BreedListViewRoute {
  case detail(BreedListDetailViewModelProtocol)
}

//MARK: - BreedListViewModelDelegate
protocol BreedListViewModelDelegate: AnyObject {
  func handleViewModelOutput(_ output: BreedListViewModelOutput)
  func navigate(to route: BreedListViewRoute)
  func notifyTableView()
}

//MARK: - BreedListViewModelOutput
extension BreedListViewModelOutput {
  static func == (lhs: BreedListViewModelOutput, rhs: BreedListViewModelOutput) -> Bool {
    switch (lhs, rhs) {
    case (.setTitle(let a), .setTitle(let b)):
      return a == b
    case (.setLoading(let a), .setLoading(let b)):
      return a == b
    case (.showBreeds(let a), .showBreeds(let b)):
      return a == b
    default:
      return false
    }
  }
}
