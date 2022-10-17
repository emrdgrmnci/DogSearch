//
//  DogBreed.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-10.
//

import Foundation

// MARK: - DogBreed
struct DogBreed: Codable, Hashable, Equatable {
    let message: [String: [String]]
    let status: String
}

extension DogBreed {
  static func fake() -> DogBreed {
    return self.init(message: ["affenpinscher" : [""]], status: "success")
  }
}
