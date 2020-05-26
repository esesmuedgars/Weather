//
// Copyright © 2020 @esesmuedgars.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var coordinator: FlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
          return true
        }
        #endif
        
        window = UIWindow(frame: UIScreen.main.bounds)
    
        coordinator = AppFlowCoordinator(window: window)
        coordinator?.startRootController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

