//
//  BreedListViewModel.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import Foundation
import UIKit
import Combine

final class BreedListViewModel {
  
  //MARK: - Variables
  weak var delegate: BreedListViewModelDelegate?
  private let breedListClient: BreedListClientProtocol
  private let breedListDetailClient: BreedListDetailClientProtocol
  private var breeds: DogBreed
  private var breedImages: BreedImages
  
  var subscriptions: Set<AnyCancellable> = []
  
  //Dependency Injection
  init(breedListClient: BreedListClientProtocol, breedListDetailClient: BreedListDetailClientProtocol) {
    self.breedListClient = breedListClient
    self.breedListDetailClient = breedListDetailClient
    self.breeds = DogBreed(message: [String : [String]](), status: String())
    self.breedImages = BreedImages(message: [String](), status: String())
  }
}

extension BreedListViewModel: BreedListViewModelProtocol {
  
  //MARK: - Get Breed List from API
  func load() {
    notify(.setTitle("Dog Breeds"))
    notify(.setLoading(true))
    
    breedListClient.getBreeds()
      .sink(receiveCompletion: { (completion) in
        switch completion {
        case .finished:
          self.notify(.setLoading(false))
        case .failure(let error):
          self.delegate?.handleViewModelOutput(.showError(error))
          self.notify(.setLoading(false))
        }
      }) { [weak self] (breeds) in
        self?.notify(.setLoading(false))
        self?.delegate?.handleViewModelOutput(.showBreeds(breeds))
        self?.breeds = breeds
      }
      .store(in: &subscriptions)
  }
  
  //MARK: - Select Breead at Index
  func selectBreed(at index: Int, breedQuery: String) {
    if breeds.message.values.count > 0 {
      breedListDetailClient.getBreedImages(breedQuery: breedQuery)
        .sink(receiveCompletion: { (completion) in
          switch completion {
          case .finished:
            self.notify(.setLoading(false))
          case .failure(let error):
            self.delegate?.handleViewModelOutput(.showError(error))
            self.notify(.setLoading(false))
          }
        }) { [weak self] (breedImages) in
          self?.notify(.setLoading(false))
          self?.delegate?.handleViewModelOutput(.showBreedImages(breedImages))
          self?.breedImages = breedImages
          
          let viewModel = BreedListDetailViewModel(breedImageDetail: breedImages)
          viewModel.detailNavigationTitle = breedQuery.capitalized
          self?.delegate?.navigate(to: .detail(viewModel))
        }
        .store(in: &subscriptions)
    }
  }
  
  //MARK: - Notify Breed List View 
  private func notify(_ output: BreedListViewModelOutput) {
    delegate?.handleViewModelOutput(output)
  }
}

