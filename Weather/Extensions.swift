//
// Copyright © 2020 @esesmuedgars.
//

import UIKit
import CoreLocation

extension UIStoryboard {
    func instantiateViewController<ViewController: UIViewController>(ofType type: ViewController.Type) -> ViewController {
        instantiateViewController(identifier: String(describing: type))
    }
}

extension CLAuthorizationStatus {
    var stringValue: String {
        switch self {
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        @unknown default:
            return "unknown"
        }
    }
}
