//
//  ReviewsFilterTests.swift
//  AppStoreReviewsTests
//
//  Created by Manali Mogre on 01/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import XCTest
@testable import AppStoreReviews

class ReviewsFilterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFilterReviews() throws {
        guard
            let path = Bundle.main.path(forResource: "Reviews", ofType: "json")
            else {
                XCTFail("Missing file: Reviews.json")
                return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(Feeds.self, from: data)
        let reviews = response.feed.entry
        
        let reviewsFilter = ReviewsFilter(reviews: reviews)
        let filteredReviews = reviewsFilter.filterReviews(ratingsSelected: [5])
        XCTAssertNotNil(filteredReviews)
        XCTAssert(filteredReviews.count == 1)
        XCTAssert((filteredReviews as Any) is [Review])
        
        let filteredReviews1 = reviewsFilter.filterReviews(ratingsSelected: [1,2,3,4])
        XCTAssertNotNil(filteredReviews1)
        XCTAssert(filteredReviews1.isEmpty)
        XCTAssert(filteredReviews1.count == 0)
        XCTAssert((filteredReviews1 as Any) is [Review])
        
        let filteredReviews2 = reviewsFilter.filterReviews(ratingsSelected: [1,2,3,4,5])
        XCTAssertNotNil(filteredReviews2)
        XCTAssert(filteredReviews2.count == 1)
        XCTAssert((filteredReviews2 as Any) is [Review])

        
    }

}
