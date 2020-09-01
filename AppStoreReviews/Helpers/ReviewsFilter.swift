//
//  ReviewsFilter.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 01/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

protocol DataFilter {
    func filterReviews(ratingsSelected:[Int])-> [Review]
}

struct ReviewsFilter: DataFilter {
    var userReviews: [Review] = [Review]()
    init(reviews: [Review]) {
        self.userReviews = reviews
    }

    func filterReviews(ratingsSelected:[Int])-> [Review] {
        let filteredReviews: [Review]!
        guard !ratingsSelected.isEmpty else {
            filteredReviews = [Review]()
            return filteredReviews!
        }
        filteredReviews =  self.userReviews.filter(){ratingsSelected.contains(Int(($0.rating?.ratingValue ?? "0")) ?? 0)}
        return filteredReviews!
    }
}
