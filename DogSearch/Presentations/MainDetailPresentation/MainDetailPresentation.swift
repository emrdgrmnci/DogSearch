//
//  MainDetailPresentation.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation

struct MainDetailPresentation: Equatable {
  let imageTitle: String
  let thumbnail: String
  let author: String
  let url: String
}

extension MainDetailPresentation {
  init(image: ChildData) {
    self.init(imageTitle: image.title, thumbnail: image.thumbnail, author: image.author, url: image.url)
  }
}
