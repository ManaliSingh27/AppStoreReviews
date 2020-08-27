//
//  APIService.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation
import UIKit
import Combine


enum CustomError: String, Error {
    case authenticationError
    case downloadError
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authenticationError:
            return "There seems to be some problem. Please try again later"
        case .downloadError:
            return "Download Failed. Please try again later"
        }
    }
}


class APIService {
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
        ]
        return URLSession(configuration: config)
    }
    
    
    public func downloadReviews(url:URL) -> AnyPublisher<Feeds, Error>{
        var dataPublisher: AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
        dataPublisher = session
            .dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
        return dataPublisher
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw CustomError.downloadError
                }
                return output.data
        }
        .retry(3)
        .decode(type: Feeds.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    public func cancelDownloadForTask(withURL url: URL) {
        session.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == url }.first?
                .cancel()
        }
    }
}
