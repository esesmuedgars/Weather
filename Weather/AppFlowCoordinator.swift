//
// Copyright © 2020 @esesmuedgars.
//

import UIKit

protocol FlowCoordinator: class {
    func startRootController()
}

final class AppFlowCoordinator: FlowCoordinator {
        
    private let storyboard = UIStoryboard(name: "Main", bundle: .main)
    private let window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func startRootController() {
        setRootWeatherViewController()
        
        window?.rootViewController = navigationController
    }
    
    private func setRootWeatherViewController() {
        let viewController = storyboard.instantiateViewController(
            ofType: WeatherViewController.self
        )
        
        let viewModel = WeatherViewModel()
        viewController.viewModel = viewModel
        
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
