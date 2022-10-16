//
//  PhotoClient.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

final class BreedListClient: BreedListClientProtocol {
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

  func getBreeds() -> AnyPublisher<DogBreed, APIServiceErrors> {
    //Combine for networking
    return URLSession.shared.dataTaskPublisher(for: Endpoints.getAllBreeds.url)
      .map(\.data) // ask for Photo data
      .decode(type: DogBreed.self, decoder: JSONDecoder())
      .mapError({ error -> APIServiceErrors in
        if let _ = error as? DecodingError {
          return APIServiceErrors.failedToParseGetPhotos
        }
        return APIServiceErrors.failedToGetPhotos
      })
      .map { $0 }
      .receive(on: DispatchQueue.main) //what thread data received from (on main thread)
      .eraseToAnyPublisher()
  }

  func getBreedImages(breedQuery: String) -> AnyPublisher<BreedImages, APIServiceErrors> {
    //Combine for networking
    return URLSession.shared.dataTaskPublisher(for: Endpoints.getImagesOfBreeds(breedQuery).url)
      .map(\.data) // ask for Photo data
      .decode(type: BreedImages.self, decoder: JSONDecoder())
      .mapError({ error -> APIServiceErrors in
        if let _ = error as? DecodingError {
          return APIServiceErrors.failedToParseGetPhotos
        }
        return APIServiceErrors.failedToGetPhotos
      })
      .map { $0 }
      .receive(on: DispatchQueue.main) //what thread data received from (on main thread)
      .eraseToAnyPublisher()
  }
}
