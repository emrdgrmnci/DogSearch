//
//  MockDetailViewModelOutput.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-09.
//

import Foundation

final class MockDetailViewModelOutput: BreedListDetailViewModelDelegate {

  var outputs: [BreedListDetailPresentation] = []

  func showDetail(_ presentation: BreedListDetailPresentation) {
    outputs.append(presentation)
  }


  func handleViewModelOutput(_ output: BreedListDetailViewModelOutput) { }

  func navigate(to route: BreedListDetailViewRoute) { }

  func notifyTableView() { }
}
