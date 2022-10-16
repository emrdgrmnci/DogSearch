//
//  BreedListViewControllerBuilder.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import UIKit

//MARK: - Builder of BreedListViewController
final class BreedListViewControllerBuilder {
  static func make() -> BreedListViewController {
    let viewController = BreedListViewController()
    let client = BreedListClient()
    viewController.viewModel = BreedListViewModel(service: client)
    return viewController
  }
}


