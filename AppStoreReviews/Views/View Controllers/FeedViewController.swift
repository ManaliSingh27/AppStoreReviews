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
    lazy var activityIndicator = UIActivityIndicatorView()
    private var feedViewModel: FeedViewModel!
    private var isFilterApplied = false
    private var ratingsSelected: [Int]?
    private var filterButton: UIBarButtonItem!
    private var subscriptions = [AnyCancellable]()
    private let networkDetector = NetworkDetection()

    lazy var reviewsRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedViewModel = FeedViewModel(delegate:self, filterDelegate:self)
        setUpViews()
        let queue = DispatchQueue(label: "Monitor")
        networkDetector.monitor.start(queue: queue)
        downloadReviews()

    }
    
    private func setUpViews() {
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 160
        tableView.addSubview(self.reviewsRefreshControl)

        filterButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(showFilterView))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func showFilterView(_ sender: UIBarButtonItem) {
        if feedViewModel.numberOfReviews(isFilterApplied: false) > 0 {
            let filterViewController: FilterViewController = FilterViewController()
            filterViewController.delegate = self
            filterViewController.ratingsSelected = self.ratingsSelected == nil ? [Int]() : self.ratingsSelected!
            
            filterViewController.modalPresentationStyle = .popover
            guard let popoverPresentationController = filterViewController.popoverPresentationController else { return }
            popoverPresentationController.barButtonItem = sender
            filterViewController.preferredContentSize = CGSize(width: 200, height: 250)
            popoverPresentationController.delegate = self
            self.present(filterViewController, animated: true, completion: nil)
        }
    }
    
    private func downloadReviews() {
        if networkDetector.currentStatus {
            self.showActivityIndicatory(activityIndicator: self.activityIndicator)
            self.feedViewModel.downloadReviews()
        }
        
        networkDetector.startNetworkMonitoring()
            .sink(receiveValue: {value in
                switch(value) {
                case ConnectionStatus.kConnected.rawValue:
                    self.showActivityIndicatory(activityIndicator: self.activityIndicator)
                    self.feedViewModel.downloadReviews()
                case ConnectionStatus.kNotConnected.rawValue:
                    self.showAlert(title:ErrorConstants.kError, message: ErrorConstants.kNoInternetError)
                default:
                    print("not connected")
                }
            })
            .store(in: &subscriptions)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect.zero)
        let headerViewModel = feedViewModel.reviews(isFilterApplied: isFilterApplied)
        headerView.showTopOccuringWords(viewModel: headerViewModel, count: Constants.kNumberOfTopOccuringWords)
        return headerView
    }
}

extension FeedViewController: ReviewsDownloadedDelegate {
    func reviewsDownloadedWithSuccess() {
        self.removeActivityIndicator(activityIndicator: self.activityIndicator)
        self.tableView.reloadData()
    }
    
    func reviewsDownloadFailure(message: String) {
        self.removeActivityIndicator(activityIndicator: self.activityIndicator)
        self.showAlert(title:ErrorConstants.kError, message: message)
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
    func showFilteredReviews(for ratingsselected: [Int]) {
        self.ratingsSelected = ratingsselected
        isFilterApplied = ratingsselected.isEmpty ? false : true
        filterButton.image = isFilterApplied ? UIImage(named: "filter-selected") : UIImage(named: "filter")
        feedViewModel.filterReviews(ratingsSelected: ratingsselected)
    }
}

extension FeedViewController {
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        if networkDetector.currentStatus {
            self.showActivityIndicatory(activityIndicator: self.activityIndicator)
            self.feedViewModel.downloadReviews()
        }
        reviewsRefreshControl.endRefreshing()
    }
}
