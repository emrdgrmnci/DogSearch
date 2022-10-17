//
//  DogSearchTests.swift
//  DogSearchTests
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import XCTest

final class DogSearchTests: XCTestCase {
  private var viewModel: BreedListViewModel!
  private var viewModelOutput: MockViewModelOutput!

  let breed: DogBreed = .init(message: ["affenpinscher" : [""]], status: "success")

  override func setUp() {
    let mockClient = MockDogSearchClient()
    let mockDetailClient = MockDogSearchDetailClient()
    viewModel = BreedListViewModel(breedListClient: mockClient, breedListDetailClient: mockDetailClient)
  }
}
