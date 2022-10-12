//
//  Photo.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-10.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
  let kind: String
  let data: PhotoData
}

// MARK: - PhotoData
struct PhotoData: Codable {
  let children: [Child]
}

// MARK: - Child
struct Child: Codable, Hashable, Equatable {
  let kind: String
  let data: ChildData
}

// MARK: - ChildData
struct ChildData: Codable, Hashable {
  let subreddit, title: String
  let thumbnail: String
  let author: String
  let url: String
}


