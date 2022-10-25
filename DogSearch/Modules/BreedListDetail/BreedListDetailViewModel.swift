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
  var detailNavigationTitle: String
  private var photoPath: String?
  private var favoritePathList: [String]?
  weak var delegate: BreedListDetailViewModelDelegate?
  private let presentation: BreedListDetailPresentation
  var fileManagerService: FileStorageManager
  
  init(breedImageDetail: BreedImages) {
    self.presentation = BreedListDetailPresentation(breedImageDetail: breedImageDetail)
    self.fileManagerService = FileStorageManager()
    self.photoPath = ""
    self.favoritePathList = [""]
    self.detailNavigationTitle = ""
  }
  
  //MARK: - Select Breead at Index
  func selectBreed(at index: Int, imagePath: [String]) {
    photoPath = imagePath[index]
    detailNavigationTitle = imagePath[index]
    do {
      let _ = try fileManagerService.save(fileNamed: photoPath ?? "")
    } catch { }
  }
  
  func goToFavorite() {
    do {
      let viewModel = try FavoriteDogListViewModel(favoriteImagesFromFileManager: fileManagerService.readAllFiles() ?? [""])
      self.delegate?.navigate(to: .detail(viewModel))
    } catch { }
  }
  
  //MARK: - Present Detail Data
  func load() {
    delegate?.showDetail(presentation)
  }
}
