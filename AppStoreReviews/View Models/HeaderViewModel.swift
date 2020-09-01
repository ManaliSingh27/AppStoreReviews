//
//  HeaderViewModel.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 31/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

class HeaderViewModel {
    var userReviews: [Review]!
    init(reviews: [Review]) {
        self.userReviews = reviews
    }
    func findMostCommonOccuringWords(count: Int) -> [String] {
        let wordsSeparator = ReviewWordsSeparator(reviews: self.userReviews)
        let words = wordsSeparator.separateWords()
        
        let filterSortManager = ItemsSortManager(filterSortManager: ReviewsFilterSort())
        let sortedWords = filterSortManager.sortItemsByWordOccurrences(items: words)
        return Array(sortedWords.prefix(count))
    }
}
