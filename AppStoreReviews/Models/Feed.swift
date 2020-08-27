//
//  Feed.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation


struct Review: Decodable {
    var author: Author?
    var title: String?
    var rating: String?
    var content: String?
    var version: String?
    var id: String?
    
    private enum FeedCodingkeys: String, CodingKey {
        case title = "title"
        case rating = "im:rating"
        case content = "content"
        case version = "im:version"
        case author = "author"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FeedCodingkeys.self)
        self.title = try container.decode(Dictionary<String, String>.self, forKey:.title).values.first
        self.rating = try container.decode(Dictionary<String, String>.self, forKey:.rating).values.first
       // self.content = try container.decode(Dictionary<String, String>.self,forKey:.content).values.first
        self.version = try container.decode(Dictionary<String, String>.self, forKey:.version).values.first
        self.id = try container.decode(Dictionary<String, String>.self, forKey:.id).values.first

        self.author = try container.decode(Author.self, forKey: .author)

    }
    
 
}

struct Author: Codable {
    var authorName: String?
    var authorUri: String?
    
    private enum AuthorCodingkeys: String, CodingKey {
        case authorName = "name"
        case authorUri = "uri"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthorCodingkeys.self)
        self.authorName = try container.decode(Dictionary<String, String>.self, forKey:.authorName).values.first
        self.authorUri = try container.decode(Dictionary<String, String>.self, forKey:.authorUri).values.first      

    }
}

struct FeedEntry: Decodable {
    var entry: [Review]
}

struct Feeds: Decodable {
    var feed: FeedEntry
}
