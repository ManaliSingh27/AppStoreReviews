//
//  AppDelegate.swift
//  AppStoreReviews
//
//  Created by Dmitrii Ivanov on 21/07/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import UIKit
import Combine

class FeedViewController: UITableViewController {
    private var subscriptions = [AnyCancellable]()
    lazy var activityIndicator = UIActivityIndicatorView()
    private var feedList: [Review] = [Review]()
    private var feedViewModel: FeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 160
        feedViewModel = FeedViewModel(delegate:self)
        downloadFeeds()
    }
    
    private func downloadFeeds() {
        guard currentReachabilityStatus != .notReachable else {
            self.showAlert(title:ErrorConstants.kError, message: ErrorConstants.kNoInternetError)
            return
        }
        self.showActivityIndicatory(activityIndicator: activityIndicator)
        feedViewModel.downloadReviews()
    }
}

extension FeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.numberOfReviews()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ReviewCell
        let reviewViewModel: ReviewViewModel = self.feedViewModel.reviewAtIndex(index: indexPath.row)
        cell.configureCell(viewModel: reviewViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController(reviewViewModel: feedViewModel.reviewAtIndex(index: indexPath.row))
        navigationController!.pushViewController(vc, animated: true)
    }
}

// MARK: - News View Model delegates
extension FeedViewController: ReviewsDownloadedDelegate {
    func reviewsDownloadedWithSuccess() {
        DispatchQueue.main.async {
            self.removeActivityIndicator(activityIndicator: self.activityIndicator)
            self.tableView.reloadData()
        }
    }
    
    func reviewsDownloadFailure(message: String) {
        DispatchQueue.main.async {
            self.removeActivityIndicator(activityIndicator: self.activityIndicator)
            self.showAlert(title:ErrorConstants.kError, message: message)
        }
    }
}
