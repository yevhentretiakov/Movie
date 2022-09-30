//
//  NetworkMonitor.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 30.09.2022.
//

import Foundation
import Network

protocol NetworkMonitor {
    func isReachable(completion: @escaping BoolBlock)
}

final class DefaultNetworkMonitor: NetworkMonitor {
    // MARK: - Properties
    static let shared = DefaultNetworkMonitor()
    private let monitor = NWPathMonitor()
    
    // MARK: - Internal Methods
    func isReachable(completion: @escaping BoolBlock)  {
        monitor.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
        }
        startMonitoring()
    }
    
    // MARK: - Private Methods
    private func startMonitoring() {
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
}
