//
//  DogSearchClientTest.swift
//  DogSearchTests
//
//  Created by TextalkMedia-Emre on 2022-10-17.
//

import XCTest

class DogSearchClientTest: XCTestCase {

  func testExample() throws {
    let bundle = Bundle(for: DogSearchDetailClientTest.self)
    let url = bundle.url(forResource: "breed", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let breed = try JSONDecoder().decode(DogBreed.self, from: data)

    XCTAssertEqual(breed.message.keys.first, "affenpinscher")
    XCTAssertEqual(breed.status, "success")

  }
}
