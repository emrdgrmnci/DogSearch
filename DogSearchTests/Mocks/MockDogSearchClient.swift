//
//  MockDogSearchClient.swift
//  DogSearchTests
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import Foundation
import Combine

final class MockDogSearchClient: BreedListClientProtocol {

  let fakeResponse: DogBreed = .fake()

  func getBreeds() -> AnyPublisher<DogBreed, APIServiceErrors> {
    return Result.Publisher(fakeResponse).eraseToAnyPublisher()
  }
}
