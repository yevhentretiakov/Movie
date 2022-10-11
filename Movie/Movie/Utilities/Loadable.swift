//
//  LoadingView.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 29.09.2022.
//

import UIKit

// MARK: - Protocols
protocol Loadable: AnyObject {
    func showLoadingView()
    func hideLoadingView()
}

struct TagConstants {
    static let loadingViewTag = 1234
}

extension Loadable where Self: UIViewController {
    func showLoadingView() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = .systemBackground
        loadingView.alpha = 0.5
        
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = loadingView.center
        
        loadingView.addSubview(activityIndicator)
        
        DispatchQueue.main.async {
            self.view.addSubview(loadingView)
        }
        
        loadingView.tag = TagConstants.loadingViewTag
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            self.view.subviews.forEach { subview in
                if subview.tag == TagConstants.loadingViewTag {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
