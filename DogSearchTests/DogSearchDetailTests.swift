//
//  DogSearchDetailTests.swift
//  DogSearchDetailTests
//
//  Created by TextalkMedia-Emre on 2022-10-10.
//

import XCTest

final class DogSearchDetailTests: XCTestCase {
  private var detailViewModel: BreedListDetailViewModel!
  private var detailViewModelOutput: MockDetailViewModelOutput!

  let photo: BreedImages = .init(message: ["https://images.dog.ceo/breeds/bulldog-boston/20200710_175933.jpg"], status: "success")

  override func setUp() {
    detailViewModel = BreedListDetailViewModel(breedImageDetail: photo)
    detailViewModelOutput = MockDetailViewModelOutput()
    detailViewModel.delegate = detailViewModelOutput
  }

  func testExample() throws {
    XCTAssertEqual(detailViewModelOutput.outputs.count, 0)
  }
}
