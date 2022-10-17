//
//  APIServiceErrors.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import Foundation

enum APIServiceErrors: Error {
  case failedToGetPhotos
  case failedToParseGetPhotos
  case failedToGetPhotosDetail
}
