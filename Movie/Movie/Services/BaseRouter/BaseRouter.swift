//
//  BaseRouter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import UIKit

// MARK: - Protocols
protocol BaseRouter {
    func show(viewController: UIViewController, isModal: Bool, animated: Bool, completion: EmptyBlock?)
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: EmptyBlock?)
    func popToRootViewController(animated: Bool, completion: EmptyBlock?)
    func close(animated: Bool, completion: EmptyBlock?)
}

class DefaultBaseRouter: BaseRouter {
    // MARK: - Properties
    private let viewController: UIViewController
    private var navigationController: UINavigationController? {
        viewController.navigationController
    }
    
    // MARK: - Life Cycle Methods
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Internal Methods
    func show(viewController: UIViewController, isModal: Bool, animated: Bool, completion: EmptyBlock? = nil) {
        if isModal {
            let presentingViewController = navigationController ?? self.viewController
            presentingViewController.present(viewController,
                                             animated: animated,
                                             completion: completion)
        } else {
            navigationController?.pushViewController(viewController,
                                                     animated: animated,
                                                     completion: completion)
        }
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: EmptyBlock? = nil) {
        navigationController?.popToViewController(viewController,
                                                  animated: animated,
                                                  completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: EmptyBlock? = nil) {
        navigationController?.popToRootViewController(animated: animated,
                                                      completion: completion)
    }
    
    func close(animated: Bool, completion: EmptyBlock? = nil) {
        if viewController.isModal {
            dismiss(animated: animated, completion: completion)
        } else {
            pop(animated: animated, completion: completion)
        }
    }
    
    // MARK: - Private Methods
    private func dismiss(animated: Bool, completion: EmptyBlock? = nil) {
        viewController.dismiss(animated: animated, completion: completion)
    }
    
    private func pop(animated: Bool, completion: EmptyBlock? = nil) {
        navigationController?.popViewController(animated: animated,
                                                completion: completion)
    }
}
