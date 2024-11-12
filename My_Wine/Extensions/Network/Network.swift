//
//  Network.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 12.11.24.
//

import Network

class Network {
    static let shared = Network()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    var isConnected: Bool = false
    private init() {}

    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
