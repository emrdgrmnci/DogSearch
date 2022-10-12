//
//  MainDetailContracts.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation

// Detailed data presentation
protocol MainDetailViewModelDelegate: AnyObject {
  func showDetail(_ presentation: MainDetailPresentation)
}

protocol MainDetailViewModelProtocol: AnyObject {
  var delegate: MainDetailViewModelDelegate? { get set }
  func load()
}
