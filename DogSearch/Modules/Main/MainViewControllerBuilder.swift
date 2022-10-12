//
//  MainViewControllerBuilder.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit.UIStoryboard

final class MainViewControllerBuilder {
  static func make() -> MainViewController {
    let viewController = MainViewController()
    let client = PhotoClient()
    viewController.viewModel = MainViewModel(service: client)
    return viewController
  }
}

