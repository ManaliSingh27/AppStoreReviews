//
//  ItemsSortTests.swift
//  AppStoreReviewsTests
//
//  Created by Manali Mogre on 31/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import XCTest
@testable import AppStoreReviews

class FilterSortManagerTests: XCTestCase {
    let itemsSorter = ReviewsFilterSort()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSortIntegerItems() {
        let sortedItems = itemsSorter.sortItemsByOccurrences(items: [2,4,4,4,1,2])
        XCTAssertEqual(sortedItems, [4,2,1])

    }
    
    func testSortStringItems() {
        let sortedItems = itemsSorter.sortItemsByOccurrences(items: ["hello","how","are", "you", "hello","you", "hello", "hello", "you","are"])
        XCTAssertEqual(sortedItems, ["hello","you", "are", "how"])
    }
    
    func testFilterStringItems() {
        let items = ["hello", "how", "are", "you", "in", "a", "of", ",", "on", "of", "a"]
        let filteredItems = itemsSorter.filterItemsByLength(items: items, moreThan: 4)
        XCTAssert(filteredItems.contains("hello"))
        XCTAssert(!filteredItems.contains("how"))
        XCTAssert(!filteredItems.contains("are"))
        XCTAssert(!filteredItems.contains("you"))

        XCTAssert(!filteredItems.contains("in"))
        XCTAssert(!filteredItems.contains("a"))
        XCTAssert(!filteredItems.contains("of"))
        XCTAssert(!filteredItems.contains(","))
        XCTAssert(!filteredItems.contains("on"))

    }

}
