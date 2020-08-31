//
//  WordsFrequencySorter.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 30/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

protocol ItemsSorter {
    func sortItemsByOccurrences<T: Hashable>(items: [T]) -> [T]
}

protocol ItemsFilter {
    func filterItemsByLength(items: [String], moreThan length: Int) -> [String]
}

typealias ItemsSortFilter = ItemsFilter & ItemsSorter

struct ReviewsFilterSort: ItemsSortFilter {
    
    func sortItemsByOccurrences<T: Hashable>(items: [T]) -> [T] {
        var dict = [T: Int]()
        _ = items.map {item in
            dict[item] = dict[item] == nil ? 1 : dict[item]!+1
        }
        let result = dict.sorted { $0.value > $1.value }.map { $0.key }
        return result
    }
    
    func filterItemsByLength(items: [String], moreThan length: Int) -> [String] {
        return items.filter{$0.count >= length}
    }
}

class FilterSortManager {
    var filterSortManager: ItemsSortFilter
    init(filterSortManager: ItemsSortFilter) {
        self.filterSortManager = filterSortManager
    }
    
    func sortItemsByWordOccurrences<T: Hashable>(items: [T]) -> [T]  {
        let filteredItems = self.filterSortManager.filterItemsByLength(items: items as! [String], moreThan: Constants.kMinimumWordLength)
        return self.filterSortManager.sortItemsByOccurrences(items: filteredItems) as! [T]
    }
    
}
