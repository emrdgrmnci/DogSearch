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
  var detailNavigationTitle: String { get set }
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

