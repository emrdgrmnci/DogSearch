//
//  MockDogSearchDetailClient.swift
//  DogSearchTests
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import Foundation
import Combine

final class MockDogSearchDetailClient: BreedListDetailClientProtocol {

  let fakeResponse: BreedImages = .fake()

  func getBreedImages(breedQuery: String) -> AnyPublisher<BreedImages, APIServiceErrors> {
    return Result.Publisher(fakeResponse).eraseToAnyPublisher()
  }

}
