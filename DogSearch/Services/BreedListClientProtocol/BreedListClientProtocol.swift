//
//  BreedListClientProtocol.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

protocol BreedListClientProtocol {
  func getBreeds() -> AnyPublisher<DogBreed, APIServiceErrors>
}
