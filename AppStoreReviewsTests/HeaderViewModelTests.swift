//
//  HeaderViewModelTests.swift
//  AppStoreReviewsTests
//
//  Created by Manali Mogre on 01/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import XCTest
@testable import AppStoreReviews

class HeaderViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCommonOccuringWords() throws {
        guard
            let path = Bundle.main.path(forResource: "Reviews", ofType: "json")
            else {
                XCTFail("Missing file: Reviews.json")
                return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(Feeds.self, from: data)
        let reviews = response.feed.entry
        
        let headerViewModel = HeaderViewModel(reviews: reviews)
        let commonWords = headerViewModel.findMostCommonOccuringWords(count: 3)
        XCTAssertEqual(commonWords[0], "Test")
        XCTAssertEqual(commonWords[1], "Review")
        XCTAssertEqual(commonWords[2], "Purpose")

    }
  

}
