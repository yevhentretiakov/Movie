//
//  UIViewController+Extensions.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import UIKit

fileprivate var loadingView: UIView!

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            actions.forEach { action in
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    var isModal: Bool {
        return presentingViewController != nil
    }
    
    func showLoadingView() {
        loadingView = UIView(frame: view.bounds)
        view.addSubview(loadingView)
        
        loadingView.backgroundColor = .systemBackground
        loadingView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            loadingView.alpha = 0.5
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        loadingView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
        loadingView = nil
    }
}
