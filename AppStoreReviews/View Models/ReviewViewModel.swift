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
        return self.review.title?.titleText ?? ""
    }
    
    var reviewContent: String {
        return self.review.content?.contentText ?? ""
    }
    
    var ratingVersionText: String {
        let version = self.review.version
        guard self.review.rating?.ratingValue != nil
            else {
                return "ver: \(version?.verionNumber ?? "")"
        }
        let rating = Int(self.review.rating?.ratingValue! ?? "0")
        var stars = ""
        guard rating != nil else {
            return "ver: \(version?.verionNumber ?? "")"
        }
        for _ in 0..<rating! {
            stars += "⭐️"
        }
        return "\(stars) (ver: \(version?.verionNumber ?? ""))"
    }
}
