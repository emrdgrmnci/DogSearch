//
//  DogSearchDetailTests.swift
//  DogSearchDetailTests
//
//  Created by TextalkMedia-Emre on 2022-10-10.
//

import XCTest

final class DogSearchDetailTests: XCTestCase {
  private var detailViewModel: MainDetailViewModel!
  private var detailViewModelOutput: MockDetailViewModelOutput!

  let photo: Child =
    .init(kind: "t3", data: ChildData(subreddit: "cat", title: "So much happiness looking at him", thumbnail: "https://a.thumbs.redditmedia.com/UOCZSLfoAhfjZMzrVSjzfc5eem-BI1nMt2fvS-_-Ml0.jpg", author: "Freon24", url: "https://i.redd.it/6xy7y3yygks91.jpg"))

  override func setUp() {
    detailViewModel = MainDetailViewModel(photoDetail: photo)
    detailViewModelOutput = MockDetailViewModelOutput()
    detailViewModel.delegate = detailViewModelOutput
  }

  func testExample() throws {
    XCTAssertEqual(detailViewModelOutput.outputs.count, 0)
  }
}
