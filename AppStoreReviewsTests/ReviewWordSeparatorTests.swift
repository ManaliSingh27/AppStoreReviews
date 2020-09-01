//
//  HeaderViewModelTests.swift
//  AppStoreReviewsTests
//
//  Created by Manali Mogre on 01/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import XCTest
@testable import AppStoreReviews

class ReviewWordSeparatorTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSeparateWords() throws {
        guard
            let path = Bundle.main.path(forResource: "Reviews", ofType: "json")
            else {
                XCTFail("Missing file: Reviews.json")
                return
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(Feeds.self, from: data)
        let reviews = response.feed.entry
        let wordsSeparater = ReviewWordsSeparator(reviews: reviews)
        let separatedWords = wordsSeparater.separateWords()
        XCTAssert(separatedWords.count == 6)
        XCTAssert(separatedWords.contains("Test"))
        XCTAssert(separatedWords.contains("Purpose"))
        XCTAssert(separatedWords.contains("Review"))
    }
    
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
