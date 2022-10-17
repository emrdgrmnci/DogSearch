//
//  MockViewModelOutput.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-09.
//

import Foundation

final class MockViewModelOutput: BreedListViewModelDelegate {

  var outputs: [BreedListViewModelOutput] = []
  var detailRouteCalled = false

  func reset() {
    outputs.removeAll()
    detailRouteCalled = false
  }

  func handleViewModelOutput(_ output: BreedListViewModelOutput) {
    outputs.append(output)
  }

  func navigate(to route: BreedListViewRoute) {
    switch route {
    case .detail:
      detailRouteCalled = true
    }
  }


  func notifyTableView() { }
}
