//
//  ReviewModelTests.swift
//  AppStoreReviewsTests
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import XCTest
@testable import AppStoreReviews

class ReviewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   func testReviewsJsonResponse() throws {
      guard
          let path = Bundle.main.path(forResource: "Reviews", ofType: "json")
          else {
              XCTFail("Missing file: Reviews.json")
              return
      }
      
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      let response = try JSONDecoder().decode(Feeds.self, from: data)
      XCTAssertNotNil(response)
      XCTAssert((response as Any) is Feeds)
      
    let reviews: [Review] = response.feed.entry
      let review: Review = reviews.first!
    XCTAssertNotNil(review.author?.authorName)
    XCTAssertNotNil(review.author?.authorUri)
    XCTAssertNotNil(review.title?.titleText)
    XCTAssertNotNil(review.content?.contentText)
    XCTAssertNotNil(review.rating?.ratingValue)
    XCTAssertNotNil(review.version?.verionNumber)

    XCTAssert((review.author?.authorName as Any) is String)
    XCTAssert((review.title?.titleText as Any) is String)
    XCTAssert((review.content?.contentText as Any) is String)
    XCTAssert((review.rating?.ratingValue as Any) is String)
    XCTAssert((review.version?.verionNumber as Any) is String)
      
  }
  

}
