//
//  BreedListDetailClientProtocol.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import Foundation
import Combine

protocol BreedListDetailClientProtocol {
  func getBreedImages(breedQuery: String) -> AnyPublisher<BreedImages, APIServiceErrors>
}
