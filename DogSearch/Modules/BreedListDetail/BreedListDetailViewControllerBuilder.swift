//
//  BreedListDetailViewControllerBuilder.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit

//MARK: - Builder of BreedListDetailViewController
final class BreedListDetailViewControllerBuilder {
  static func make(with viewModel: BreedListDetailViewModelProtocol) -> BreedListDetailViewController {
    let viewController = BreedListDetailViewController()
    viewController.detailViewModel = viewModel
    return viewController
  }
}
