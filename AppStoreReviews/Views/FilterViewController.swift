//
//  FilterViewController.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate
{
    func showFilteredReviews(for ratingsselected: [Int])
}

class FilterViewController: UITableViewController {
    
    var delegate: FilterViewControllerDelegate?
    
    var ratingsSelected: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        tableView.register(FilterCell.self, forCellReuseIdentifier: "cellId")
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 50
    }
}

extension FilterViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! FilterCell
        cell.configureCell(rating: (indexPath.row + 1))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !ratingsSelected!.contains(indexPath.row + 1) {
            ratingsSelected!.append(indexPath.row + 1)
        }
        else{
            ratingsSelected!.removeAll{$0 == indexPath.row + 1}
            
        }
        self.delegate?.showFilteredReviews(for: ratingsSelected!)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if ratingsSelected!.contains(indexPath.row + 1) {
            ratingsSelected!.removeAll{$0 == indexPath.row + 1}
        }
        self.delegate?.showFilteredReviews(for: ratingsSelected!)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (ratingsSelected?.contains(indexPath.row + 1))! {
            cell.setSelected(true, animated: false)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none) 
        }
    }
    
}
