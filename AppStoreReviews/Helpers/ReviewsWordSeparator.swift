//
//  ReviewsWordSeparator.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 31/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

protocol WordsSeparator {
    func separateWords()-> [String]
}

struct ReviewWordsSeparator: WordsSeparator {
    var userReviews: [Review] = [Review]()
    init(reviews: [Review]) {
        self.userReviews = reviews
    }

    func separateWords() -> [String] {
        let words = self.userReviews.compactMap{$0.content?.contentText?.components(separatedBy: CharacterSet.whitespacesAndNewlines)}.flatMap{$0}
        return words
    }
}
