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


class FeedViewModel: NSObject {
    weak var delegate: ReviewsDownloadedDelegate!
    weak var filterDelegate: ReviewsFilteredDelegate!
    
    private var subscriptions = [AnyCancellable]()
    private var apiService: DownloadService?
    private var reviews: [Review] {
        didSet {
            self.seperateWords(reviews: self.reviews)

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
    
    // Downloads News Data and Parse the Response
    func downloadReviews()
    {
        
       // let url = URL(string: "https://itunes.apple.com/nl/rss/customerreviews/id=474495017/sortby=mostrecent/json")
        apiService = FileDownloadService()
        
        let path = Bundle.main.path(forResource: "Reviews", ofType: "json")
        //
        let url = URL(fileURLWithPath: path!)
        apiService?.downloadData(url: url)
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
        filteredReviews =  self.reviews.filter(){ratingsSelected.contains(Int(($0.rating?.ratingValue)!)!)}
        self.seperateWords(reviews: filteredReviews)
    }
    
    func seperateWords(reviews: [Review]) {
        
        let allWords = reviews.compactMap{$0.content?.contentText?.components(separatedBy: CharacterSet.whitespacesAndNewlines)}
        let combinedWords = allWords.flatMap{$0}
        let filteredWords = combinedWords.filter{$0.count > 3}
        print(filteredWords)
        
        self.findMostOccuringWords(words: filteredWords)
        
    }
    
    func findMostOccuringWords(words: [String]) {
        var dict = [String: Int]()
        for item in words {
            if dict[item] == nil {
                dict[item] = 1
            } else {
                dict[item]! += 1
            }
        }
       // let result = dict.sorted { $0.value > $1.value }.map { $0.key }
        let result = dict.sorted { $0.value > $1.value }
        print(result)
        
        
    }
}
