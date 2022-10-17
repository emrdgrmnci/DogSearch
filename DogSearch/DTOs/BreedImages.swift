//
//  BreedImages.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import Foundation


// MARK: - BreedImages
struct BreedImages: Codable, Hashable, Equatable {
  var message: [String]
    let status: String
}

extension BreedImages {
  static func fake() -> BreedImages {
    return self.init(message: ["https://images.dog.ceo/breeds/bulldog-boston/20200710_175933.jpg"], status: "success")
  }
}
