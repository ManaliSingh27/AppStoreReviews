//
//  Feed.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation


struct Review: Codable {
    var author: Author?
    var title: Title?
    var rating: Rating?
    var content: Content?
    var version: Version?
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
        self.title = try container.decode(Title.self, forKey:.title)
        self.rating = try container.decode(Rating.self, forKey:.rating)
        self.content = try container.decode(Content.self, forKey:.content)
        self.version = try container.decode(Version.self, forKey:.version)
        self.id = try container.decode(Dictionary<String, String>.self, forKey:.id).values.first
        
        self.author = try container.decode(Author.self, forKey: .author)
        
    }
    
}

struct Rating: Codable {
    var ratingValue: String?
    private enum RatingCodingkeys: String, CodingKey {
        case ratingValue = "label"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RatingCodingkeys.self)
        self.ratingValue = try container.decode(String.self, forKey:.ratingValue)
    }
}

struct Version: Codable {
    var verionNumber: String?
    private enum VersionCodingkeys: String, CodingKey {
        case verionNumber = "label"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VersionCodingkeys.self)
        self.verionNumber = try container.decode(String.self, forKey:.verionNumber)
    }
}

struct Title: Codable {
    var titleText: String?
    private enum TitleCodingkeys: String, CodingKey {
        case titleText = "label"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TitleCodingkeys.self)
        self.titleText = try container.decode(String.self, forKey:.titleText)
    }
}

struct Content: Codable {
    var contentText: String?
    private enum ContentCodingkeys: String, CodingKey {
        case contentText = "label"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContentCodingkeys.self)
        self.contentText = try container.decode(String.self, forKey:.contentText)
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

struct FeedEntry: Codable {
    var entry: [Review]
}

struct Feeds: Codable {
    var feed: FeedEntry
}
