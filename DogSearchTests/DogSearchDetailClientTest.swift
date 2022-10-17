//
//  DogSearchDetailClientTest.swift
//  DogSearchClientTest
//
//  Created by TextalkMedia-Emre on 2022-10-09.
//

import XCTest

final class DogSearchDetailClientTest: XCTestCase {
  
  func testExample() throws {
    let bundle = Bundle(for: DogSearchDetailClientTest.self)
    let url = bundle.url(forResource: "photo", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let photo = try JSONDecoder().decode(BreedImages.self, from: data)

    XCTAssertEqual(photo.message[0], "https://images.dog.ceo/breeds/bulldog-boston/20200710_175933.jpg")
  }
}
