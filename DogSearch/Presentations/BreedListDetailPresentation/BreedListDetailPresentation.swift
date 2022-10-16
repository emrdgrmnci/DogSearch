//
//  BreedListDetailPresentation.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import Foundation

//MARK: - BreedListDetailPresentation
struct BreedListDetailPresentation: Equatable {
  let breedImages: [String]
}

extension BreedListDetailPresentation {
  init(breedImageDetail: BreedImages) {
    self.init(breedImages: breedImageDetail.message)
  }
}
