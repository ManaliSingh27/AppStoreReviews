//
//  Constants.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

struct Constants {
    static let kNumberOfTopOccuringWords: Int = 3
}

struct ErrorConstants {
    static let kParsingFailedError: String = "There seems to be some issue. Please try again later"
    static let kError: String = "Error"
    static let kNoInternetError: String = "There seems to be some problem in network. Please try again later"
    static let kErrorAPIResponse: String = "There seems to be some issue. Please try again later"
    static let kErrorAPINoData: String = "There is no data to show"
}

struct URLConstants {
    static let kReviewsUrl: String = "https://itunes.apple.com/nl/rss/customerreviews/id=474495017/sortby=mostrecent/json"
}


