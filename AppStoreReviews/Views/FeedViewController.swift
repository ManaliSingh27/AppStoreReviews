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
    private var isFilterApplied = false
    private var ratingsSelected: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 160
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(showFilter))
        navigationItem.rightBarButtonItem = button
        
        feedViewModel = FeedViewModel(delegate:self, filterDelegate:self)
        downloadFeeds()
    }
    
    @objc private func showFilter(_ sender: UIBarButtonItem) {
        let filterViewController: FilterViewController = FilterViewController()
        filterViewController.delegate = self
        if self.ratingsSelected != nil {
            filterViewController.ratingsSelected = self.ratingsSelected!
        }
        else {
            filterViewController.ratingsSelected = [Int]()
        }
        filterViewController.modalPresentationStyle = .popover
        
        guard let popoverPresentationController = filterViewController.popoverPresentationController else { fatalError("Set Modal presentation style") }
        popoverPresentationController.barButtonItem = sender
        filterViewController.preferredContentSize = CGSize(width: 200, height: 250)
        popoverPresentationController.delegate = self
        self.present(filterViewController, animated: true, completion: nil)
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
        return feedViewModel.numberOfReviews(isFilterApplied: isFilterApplied)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ReviewCell
        let reviewViewModel: ReviewViewModel = self.feedViewModel.reviewAtIndex(index: indexPath.row, isFilterApplied: isFilterApplied)
        cell.configureCell(viewModel: reviewViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController(reviewViewModel: feedViewModel.reviewAtIndex(index: indexPath.row, isFilterApplied: isFilterApplied))
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

extension FeedViewController: ReviewsFilteredDelegate {
    func reviewsFilteredWithSuccess() {
        DispatchQueue.main.async {
            self.removeActivityIndicator(activityIndicator: self.activityIndicator)
            self.tableView.reloadData()
        }
    }
}

extension FeedViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

extension FeedViewController: FilterViewControllerDelegate {
    func childViewControllerResponse(ratingsselected: [Int]) {
        self.ratingsSelected = ratingsselected
        isFilterApplied = ratingsselected.isEmpty ? false : true
        feedViewModel.filterReviews(ratingsSelected: ratingsselected)
    }
}
