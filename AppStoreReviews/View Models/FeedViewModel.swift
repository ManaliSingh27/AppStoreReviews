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

protocol ReviewsFilteredDelegate: class {
    func reviewsFilteredWithSuccess()
}

protocol AppStoreReviewsDownloader {
    func downloadAppStoreReviews()
}


class FeedViewModel: NSObject {
    weak var delegate: ReviewsDownloadedDelegate!
    weak var filterDelegate: ReviewsFilteredDelegate!
    private var subscriptions = [AnyCancellable]()
    private var apiService: DownloadService?
    private var reviews: [Review] {
        didSet {
            self.delegate?.reviewsDownloadedWithSuccess()
        }
    }
    private var filteredReviews: [Review] {
        didSet {
            self.filterDelegate?.reviewsFilteredWithSuccess()
        }
    }
    
    init(delegate: ReviewsDownloadedDelegate?, filterDelegate: ReviewsFilteredDelegate) {
        self.reviews = [Review]()
        self.filteredReviews = [Review]()
        self.delegate = delegate
        self.filterDelegate = filterDelegate
    }
    
    func downloadReviews() {
        self.downloadAppStoreReviews()
    }
    
    func numberOfReviews(isFilterApplied: Bool) -> Int {
        return isFilterApplied ? self.filteredReviews.count : self.reviews.count
    }
    
    func reviewAtIndex(index: Int, isFilterApplied: Bool) -> ReviewViewModel {
        return isFilterApplied ? ReviewViewModel(review: self.filteredReviews[index]) : ReviewViewModel(review: self.reviews[index])
    }
    
    func filterReviews(ratingsSelected: [Int]) {
        guard !ratingsSelected.isEmpty else {
            filteredReviews = [Review]()
            return
        }
        filteredReviews =  self.reviews.filter(){ratingsSelected.contains(Int(($0.rating?.ratingValue ?? "0")) ?? 0)}
    }
    
    func findMostCommonOccuringWords() -> [String] {
        var userReviews: [Review] = reviews
        if !filteredReviews.isEmpty {
            userReviews = filteredReviews
        }
        let wordsSeparator = ReviewWordsSeparator(reviews: userReviews)
        let words = wordsSeparator.separateWords()
        let sortedWords = ReviewsFilterSort().getSortedReviewsByOccurrences(items: words)
        return Array(sortedWords.prefix(Constants.kNumberOfTopOccuringWords))
    }
}

extension FeedViewModel: AppStoreReviewsDownloader {
    func downloadAppStoreReviews() {
        let url = URL(string: URLConstants.kReviewsUrl)
        guard url != nil else {
            return
        }
        apiService = NetworkAPIService()
        let manager = APIServiceManager(apiService: apiService!)
        manager.downloadReviews(url: url!)
            .sink(receiveCompletion: {completion in
                switch(completion){
                case .failure(let error):
                    self.delegate?.reviewsDownloadFailure(message: error.localizedDescription)
                case .finished:
                    print("finished")
                }
            }, receiveValue: {value in
                self.reviews = (value as Feeds).feed.entry
            })
            .store(in: &subscriptions)
    }
}
