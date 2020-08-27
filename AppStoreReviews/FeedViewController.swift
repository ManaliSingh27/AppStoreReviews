//
//  AppDelegate.swift
//  AppStoreReviews
//
//  Created by Dmitrii Ivanov on 21/07/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 160
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ReviewCell
        c.update(item: randomReview())
        return c
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController(review: randomReview())
        navigationController!.pushViewController(vc, animated: true)
    }
    
    func randomReview() -> Review {
        let author = ["Dan Auerbach", "Bo Diddley", "Otis Rush", "Jimi Hendrix", "Albert King", "Buddy Guy", "Muddy Waters", "Eric Clapton"].randomElement()!
        let version = ["3.11", "3.12"].randomElement()!
        let rating = Int.random(in: 1...5)
        let title = ["Awesome app", "Could be better", "Gimme my money back!!", "Lemme tell you a story..."].randomElement()!
        let id = UUID().uuidString
        let content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        return Review(author: author,
                      version: version,
                      rating: rating,
                      title: title,
                      id: id,
                      content: content)
    }
}

