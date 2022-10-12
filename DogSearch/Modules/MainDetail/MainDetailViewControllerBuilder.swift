//
//  MainDetailViewControllerBuilder.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit.UIStoryboard

final class MainDetailViewControllerBuilder {
  static func make(with viewModel: MainDetailViewModelProtocol) -> MainDetailViewController {
    let viewController = MainDetailViewController()
    viewController.detailViewModel = viewModel
    return viewController
  }
}
