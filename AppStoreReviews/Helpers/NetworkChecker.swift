//
//  NetworkChecker.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 01/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation
import Network
import Combine

enum ConnectionStatus: String {
    case kNotConnected = "Not Connected"
    case kConnected = "Connected"
}

protocol NetworkChecker {
    func startNetworkMonitoring() -> AnyPublisher<String, Never>
}

class NetworkDetection: NetworkChecker {
    let monitor = NWPathMonitor()
    let subject = PassthroughSubject<String, Never>()
    var currentStatus: Bool = true
    
    var isNetworkConnected: Bool {
        return currentStatus
    }
    
    func startNetworkMonitoring() -> AnyPublisher<String, Never>  {
        var networkStatus: String = ConnectionStatus.kConnected.rawValue
        let publisher = subject.eraseToAnyPublisher()
        monitor.pathUpdateHandler = {[weak self] path in
            if path.status == .satisfied {
                networkStatus = ConnectionStatus.kConnected.rawValue
                self?.currentStatus = true
            } else {
                networkStatus = ConnectionStatus.kNotConnected.rawValue
                self?.currentStatus = false
            }
            self?.subject.send(networkStatus)
        }
        return publisher
            .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()

    }
}
