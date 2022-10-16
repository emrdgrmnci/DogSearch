//
//  MainViewControllerBuilder.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit

//MARK: - Builder of FavoriteDogListViewController
final class FavoriteDogListViewControllerBuilder {
  static func make(with viewModel: FavoriteDogListViewModelProtocol) -> FavoriteDogListViewController {
    let viewController = FavoriteDogListViewController()
    viewController.viewModel = viewModel
    return viewController
  }
}

