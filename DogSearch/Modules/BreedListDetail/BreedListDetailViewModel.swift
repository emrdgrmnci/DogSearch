//
//  BreedListDetailViewModel.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

final class BreedListDetailViewModel: BreedListDetailViewModelProtocol {
  
  //MARK: - Variables
  private var photoPath: String?
  private var favoritePathList: [String]?
  weak var delegate: BreedListDetailViewModelDelegate?
  private let presentation: BreedListDetailPresentation

  init(breedImageDetail: BreedImages) {
    self.presentation = BreedListDetailPresentation(breedImageDetail: breedImageDetail)
    self.photoPath = ""
    self.favoritePathList = [""]
  }
    
  //MARK: - Select Breead at Index
  func selectBreed(at index: Int, imagePath: [String]) {
    photoPath = imagePath[index]
    
    do {
      _ = try FileStorageManager.shared.save(fileNamed: photoPath ?? "")
    } catch { }
  }
  
  //MARK: - Present Detail Data
  func load() {
    delegate?.showDetail(presentation)
  }
}
