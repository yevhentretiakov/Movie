//
//  PlayerRouter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 30.09.2022.
//

import Foundation

// MARK: - Protocols
protocol PlayerRouter {
    func close()
}

final class DefaultPlayerRouter: DefaultBaseRouter, PlayerRouter {
    // MARK: - Internal Methods
    func close() {
        close(animated: true)
    }
}
