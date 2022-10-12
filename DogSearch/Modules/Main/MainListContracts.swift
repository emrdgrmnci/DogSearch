//
//  MainListContracts.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
  var delegate: MainViewModelDelegate? { get set }
  func load(query: String?)
  func selectPhoto(at index: Int)
  var isSearching: Bool { get set }
  func viewWillDisappear()
  func searchBarCancelButtonClicked()
}

enum MainViewModelOutput: Equatable {
  case setTitle(String)
  case setLoading(Bool)
  case showPhotos([Child])
  case showError(Error)
}

enum MainViewRoute {
  case detail(MainDetailViewModelProtocol)
}

protocol MainViewModelDelegate: AnyObject {
  func handleViewModelOutput(_ output: MainViewModelOutput)
  func navigate(to route: MainViewRoute)
  func notifyCollectionView()
}

extension MainViewModelOutput {
  static func == (lhs: MainViewModelOutput, rhs: MainViewModelOutput) -> Bool {
    switch (lhs, rhs) {
    case (.setTitle(let a), .setTitle(let b)):
      return a == b
    case (.setLoading(let a), .setLoading(let b)):
      return a == b
    case (.showPhotos(let a), .showPhotos(let b)):
      return a == b
    default:
      return false
    }
  }
}
