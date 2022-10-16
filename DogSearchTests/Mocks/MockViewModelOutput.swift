//
//  MockViewModelOutput.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-09.
//

import Foundation

final class MockViewModelOutput: BreedListViewModelDelegate {

  var outputs: [BreedListViewModelOutput] = []

  func handleViewModelOutput(_ output: BreedListViewModelOutput) {
    outputs.append(output)
  }

  func navigate(to route: BreedListViewRoute) { }


  func notifyTableView() { }
}
