//
//  FavoriteDogListPresentation.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-20.
//

import Foundation

struct FavoriteDogListPresentation: Equatable {
  var favImages: [String]
  
  init(favimages: [String]) {
    self.favImages = favimages
  }
}

