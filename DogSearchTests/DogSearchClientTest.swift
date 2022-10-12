//
//  DogSearchClientTest.swift
//  DogSearchClientTest
//
//  Created by TextalkMedia-Emre on 2022-10-09.
//

import XCTest

final class DogSearchClientTest: XCTestCase {
  
  func testExample() throws {
    let bundle = Bundle(for: DogSearchClientTest.self)
    let url = bundle.url(forResource: "photo", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let photo = try JSONDecoder().decode(Photo.self, from: data)

    XCTAssertEqual(photo.data.children[0].data.title, "So much happiness looking at him")
    XCTAssertEqual(photo.data.children[0].data.thumbnail, "https://a.thumbs.redditmedia.com/UOCZSLfoAhfjZMzrVSjzfc5eem-BI1nMt2fvS-_-Ml0.jpg")
    XCTAssertEqual(photo.data.children[0].data.subreddit, "cat")
    XCTAssertEqual(photo.data.children[0].data.author, "Freon24")
    XCTAssertEqual(photo.data.children[0].data.url, "https://i.redd.it/6xy7y3yygks91.jpg")
  }
}
