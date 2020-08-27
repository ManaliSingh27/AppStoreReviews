//
//  UIViewController+Util.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: - Alert Controller
    /// Shows Alert with message and title
    /// - parameter title: Title of Alert
    /// - parameter message: Alert Message
    func showAlert(title: String?, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    // MARK: - Activity Indicator
    /// Shows Activity indicator
    /// - parameter activityIndicator: activity indicator instance
    func showActivityIndicatory(activityIndicator: UIActivityIndicatorView) {
        self.view.addSubview(activityIndicator)
        activityIndicator.center =  CGPoint(x: UIScreen.main.bounds.size.width/2.0, y: UIScreen.main.bounds.size.height/2.0)
        activityIndicator.autoresizingMask = (UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleRightMargin.rawValue) | UInt8(UIView.AutoresizingMask.flexibleLeftMargin.rawValue) | UInt8(UIView.AutoresizingMask.flexibleBottomMargin.rawValue) | UInt8(UIView.AutoresizingMask.flexibleTopMargin.rawValue))))
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.frame = view.bounds
        activityIndicator.bringSubviewToFront(self.view)
        activityIndicator.startAnimating()
    }
    
    /// Shows Activity indicator
    /// - parameter activityIndicator: activity indicator instance
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
