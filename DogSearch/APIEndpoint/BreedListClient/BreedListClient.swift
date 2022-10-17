//
//  PhotoClient.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

final class BreedListClient: BreedListClientProtocol {
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
}
