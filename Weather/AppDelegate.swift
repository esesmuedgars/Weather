//
// Copyright © 2020 @esesmuedgars.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var coordinator: FlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
    
        coordinator = AppFlowCoordinator(window: window)
        coordinator?.startRootController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

