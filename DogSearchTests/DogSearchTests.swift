//
//  DogSearchTests.swift
//  DogSearchTests
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import XCTest

final class DogSearchTests: XCTestCase {
  private var viewModel: BreedListViewModelProtocol!
  private var viewModelOutput: MockViewModelOutput!
  let mockClient = MockDogSearchClient()
  let mockDetailClient = MockDogSearchDetailClient()

  let breed: DogBreed = .init(message: ["affenpinscher" : [""]], status: "success")

  override func setUp() {
    viewModel = BreedListViewModel(breedListClient: mockClient, breedListDetailClient: mockDetailClient)
    viewModelOutput = MockViewModelOutput()
    viewModel.delegate = viewModelOutput
  }

  func testExample() throws {
    viewModel.load()
    XCTAssertEqual(viewModelOutput.outputs.count, 5)

    switch viewModelOutput.outputs.first {
    case .setTitle(let title):
      XCTAssertEqual(title, "Dog Breeds")
      break //Success
    default:
      XCTFail("First output should be `setTitle`")
    }

    XCTAssertEqual(viewModelOutput.outputs[1], .setLoading(true))
    XCTAssertEqual(viewModelOutput.outputs[2], .setLoading(false))

    let expectedList: DogBreed = .fake()
    XCTAssertEqual(viewModelOutput.outputs[3], .showBreeds(expectedList))
  }

  func testNavigation() {
    //Given
    viewModel.load()
    viewModelOutput.reset()

    //When
    viewModel.selectBreed(at: 0, breedQuery: "affenpinscher")

    //Then
    XCTAssertTrue(viewModelOutput.detailRouteCalled)
  }
}
