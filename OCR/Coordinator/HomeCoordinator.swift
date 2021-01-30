//
//  ViewController.swift
//  OCR
//
//  Created by Abhi Makadiya on 30/01/21.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    // MARK: - Variables
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    func start() {
        guard let homeVC = R.storyboard.main.homeViewController() else {
            return
        }
        homeVC.coordinator = self
        navigationController.viewControllers = [homeVC]
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
    
    func goToOCRDetail(model: [OCRModel]) {
        guard let detailVC = R.storyboard.main.ocrDetailVC() else {
            return
        }
        detailVC.coordinator = self
        detailVC.arrOCR = model
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func finishToRootView() { }
}
