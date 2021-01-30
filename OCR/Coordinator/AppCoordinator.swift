//
//  ViewController.swift
//  OCR
//
//  Created by Abhi Makadiya on 30/01/21.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Variables
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
    }
    
    func finish() { }
    
    func finishToRootView() { }
    
}// End of Class
