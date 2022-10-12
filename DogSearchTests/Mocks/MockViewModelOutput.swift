//
//  MockViewModelOutput.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-09.
//

import Foundation

final class MockViewModelOutput: MainViewModelDelegate {
  var outputs: [MainViewModelOutput] = []

  func notifyCollectionView() {}

  func handleViewModelOutput(_ output: MainViewModelOutput) {
    outputs.append(output)
  }

  func navigate(to navigationType: MainViewRoute) {
    outputs.append(.setTitle("Photos"))
  }
}
