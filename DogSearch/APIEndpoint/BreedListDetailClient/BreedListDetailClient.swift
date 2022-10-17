//
//  BreedListDetailClient.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import Foundation
import Combine

final class BreedListDetailClient: BreedListDetailClientProtocol {
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
