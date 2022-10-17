//
//  Endpoints.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import Foundation

enum Endpoints {
  case getAllBreeds
  case getImagesOfBreeds(String)

  static let baseURL = "https://dog.ceo/api/" //https://dog.ceo/api/

  var baseURLValue: String {
    switch self {
    case .getAllBreeds:
      return Endpoints.baseURL + "breeds/list/all" //https://dog.ceo/api/breeds/list/all
    case .getImagesOfBreeds(let breedQuery):
      return Endpoints.baseURL + "breed/" + "\(breedQuery)/" + "images" //https://dog.ceo/api/breed/hound/images
    }
  }
  var url: URL {
    return URL(string: self.baseURLValue)!
  }
}
