//
//  MainViewModel.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import UIKit
import Combine

final class FavoriteDogListViewModel {

  //MARK: - Variables
  weak var delegate: FavoriteDogListViewModelDelegate?
  private var readAllFiles: [String]

  var subscriptions: Set<AnyCancellable> = []

  init(readAllFiles: [String]) {
    self.readAllFiles = readAllFiles
  }
}

extension FavoriteDogListViewModel: FavoriteDogListViewModelProtocol {

  //MARK: - Read Favorites from FileManager
  func load() -> [String] {
    notify(.setTitle("Favorite"))
    notify(.setLoading(true))
    do {
      readAllFiles = try FileStorageManager.shared.readAllFiles() ?? [""]
      return readAllFiles
    } catch { return [""] }
  }

  //MARK: - Notify Favorite List View
  private func notify(_ output: FavoriteDogListViewModelOutput) {
    delegate?.handleViewModelOutput(output)
  }
}
