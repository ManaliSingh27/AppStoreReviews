//
//  ReviewViewModel.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation
import UIKit

class ReviewViewModel: NSObject {
    private var review: Review

    init(review: Review) {
        self.review = review
    }
    
    var authorName: String {
        return self.review.author?.authorName ?? ""
    }
    
    var reviewTitle: String {
        return self.review.title ?? ""
    }
    
    var ratingVersionText: String {
        let rating = Int(self.review.rating!)
        var stars = ""
        for _ in 0..<rating! {
                    stars += "⭐️"
                }
        return "\(stars) (ver: \(String(describing: self.review.version!)))"
    }
}
