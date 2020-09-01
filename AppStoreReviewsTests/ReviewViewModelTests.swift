//
//  ReviewViewModelTests.swift
//  AppStoreReviewsTests
//
//  Created by Manali Mogre on 01/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import XCTest
@testable import AppStoreReviews

class ReviewViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReviewData() throws {
        guard
            let path = Bundle.main.path(forResource: "Reviews", ofType: "json")
            else {
                XCTFail("Missing file: Reviews.json")
                return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(Feeds.self, from: data)
        let reviews = response.feed.entry
        let review = reviews.first
        
        let reviewViewModel = ReviewViewModel(review: review!)
        XCTAssertEqual(reviewViewModel.authorName, "Test Author")
        XCTAssertEqual(reviewViewModel.reviewTitle, "Test Title")
        XCTAssertEqual(reviewViewModel.reviewContent, "Test Purpose Test Test Review Review")
        XCTAssertEqual(reviewViewModel.ratingVersionText, "⭐️⭐️⭐️⭐️⭐️ (ver: 2020.0.0)")

    }
    

}
