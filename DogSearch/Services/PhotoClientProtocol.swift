//
//  PhotoClientProtocol.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

protocol PhotoClientProtocol {
  func getPhotos(query: String?) -> AnyPublisher<[Child], APIServiceErrors>
}

enum APIServiceErrors: Error {
  case failedToGetPhotos
  case failedToParseGetPhotos
  case failedToGetPhotosDetail
}
