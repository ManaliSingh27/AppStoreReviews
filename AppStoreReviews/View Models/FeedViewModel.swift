//
//  FeedViewModel.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol ReviewsDownloadedDelegate: class {
    func reviewsDownloadedWithSuccess()
    func reviewsDownloadFailure(message: String)
}


class FeedViewModel: NSObject {
    weak var delegate: ReviewsDownloadedDelegate!
    private var subscriptions = [AnyCancellable]()
    private var apiService: APIService?
    private var reviews: [Review] {
        didSet {
            self.delegate?.reviewsDownloadedWithSuccess()
        }
    }
    
    init(delegate: ReviewsDownloadedDelegate?) {
        self.reviews = [Review]()
        self.delegate = delegate
    }
    
    // Downloads News Data and Parse the Response
    func downloadReviews()
    {
        let url = URL(string: "https://itunes.apple.com/nl/rss/customerreviews/id=474495017/sortby=mostrecent/json")
        apiService = APIService()
        apiService?.downloadReviews(url: url!)
            .sink(receiveCompletion: {completion in
                switch(completion){
                case .failure(let error):
                    self.delegate?.reviewsDownloadFailure(message: error.localizedDescription)
                case .finished:
                    print("finished")
                }
            }, receiveValue: {value in
                self.reviews = value.feed.entry
            })
            .store(in: &subscriptions)
    }
    
    
    func numberOfReviews() -> Int {
        return self.reviews.count
    }
    
    func reviewAtIndex(index: Int) -> ReviewViewModel {
        return ReviewViewModel(review: self.reviews[index])
    }
}
