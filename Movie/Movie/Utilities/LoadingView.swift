//
//  LoadingView.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 29.09.2022.
//

import UIKit

// MARK: - Protocols
protocol LoadingView: AnyObject {
    var loadingView: UIView? { get set }
    func showLoadingView()
    func hideLoadingView()
}

extension LoadingView where Self: UIViewController {
    func showLoadingView() {
        let loadView = UIView(frame: self.view.bounds)
        loadView.backgroundColor = .systemBackground
        loadView.alpha = 0.5
        
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = loadView.center
        
        loadView.addSubview(activityIndicator)
        
        DispatchQueue.main.async {
            self.view.addSubview(loadView)
        }
        
        self.loadingView = loadView
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
