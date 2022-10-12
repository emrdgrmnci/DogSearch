//
//  MainDetailViewModel.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation

final class MainDetailViewModel: MainDetailViewModelProtocol {
  weak var delegate: MainDetailViewModelDelegate?
  private let presentation: MainDetailPresentation

  func load() {
    delegate?.showDetail(presentation)
  }

  init(photoDetail: Child) {
    self.presentation = MainDetailPresentation(image: photoDetail.data)
  }
}
