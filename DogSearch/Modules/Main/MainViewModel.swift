//
//  MainViewModel.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import UIKit
import Combine

final class MainViewModel {

  weak var delegate: MainViewModelDelegate?
  private let service: PhotoClientProtocol
  private var photos: [Child]
  var isSearching: Bool = false
  var subscriptions: Set<AnyCancellable> = []

  init(service: PhotoClientProtocol) {
    self.service = service
    self.photos = []
  }
}

extension MainViewModel: MainViewModelProtocol {
  func load(query: String?) {
    notify(.setTitle("Photos"))
    notify(.setLoading(true))

    service.getPhotos(query: query)
      .sink(receiveCompletion: { (completion) in
        switch completion {
        case .finished:
          self.notify(.setLoading(false))
        case .failure(let error):
          self.delegate?.handleViewModelOutput(.showError(error))
          self.notify(.setLoading(false))
        }
      }) { [weak self] (photos) in
        self?.notify(.setLoading(false))
        self?.delegate?.handleViewModelOutput(.showPhotos(photos))
        self?.photos = photos
      }
      .store(in: &subscriptions)
  }

  func selectPhoto(at index: Int) {
    if photos.count > 0 {
      let photo = photos[index]
      let viewModel = MainDetailViewModel(photoDetail: photo)
      delegate?.navigate(to: .detail(viewModel))
    }
  }

  func viewWillDisappear() {
    isSearching = false
    delegate?.notifyCollectionView()
  }

  private func notify(_ output: MainViewModelOutput) {
    delegate?.handleViewModelOutput(output)
  }

  func searchBarCancelButtonClicked() {
    self.photos.removeAll()
    delegate?.notifyCollectionView()
  }
}
