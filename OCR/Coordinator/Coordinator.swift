//
//  ViewController.swift
//  OCR
//
//  Created by Abhi Makadiya on 30/01/21.
//

import UIKit

/// Coordinator to manage the flow this method are requird to implement in every coordinator
protocol Coordinator {

    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func finish()
    func finishToRootView()
}
