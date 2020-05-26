//
// Copyright © 2020 @esesmuedgars.
//

import Foundation
import CoreLocation

enum GPSServiceError: Error {
    case locationServicesDisabled
    case invalidAuthorizationStatus(_ status: CLAuthorizationStatus)
    case locationUpdateError
    case locationManagerFailedWith(error: Error)
}

extension GPSServiceError {
    var description: String {
        switch self {
        case .locationServicesDisabled:
            return "Device location services are disabled."
        case .invalidAuthorizationStatus(let status):
            return "Expected location manager authorizedWhenInUse authorization status, received \(status.stringValue)."
        case .locationUpdateError:
            return "Update location returned error."
        case .locationManagerFailedWith(let error):
            return "Location manager failed, with error: \(error)."
        }
    }
}

protocol GPSServiceProtocol: class {
    var delegate: GPSServiceDelegate? { get set }
    
    func requestAuthorization()
}

protocol GPSServiceDelegate: class {
    func gpsServiceDidUpdate(_ location: CLLocation)
    func gpsService(failedWithError error: GPSServiceError)
}

final class GPSService: NSObject, GPSServiceProtocol, CLLocationManagerDelegate {
    
    weak var delegate: GPSServiceDelegate?
    
    private var locationManager = CLLocationManager()
    
    func requestAuthorization() {
        guard CLLocationManager.locationServicesEnabled() else {
            delegate?.gpsService(failedWithError: .locationServicesDisabled)
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard case .authorizedWhenInUse = status else {
            delegate?.gpsService(failedWithError: .invalidAuthorizationStatus(status))
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        guard let location = locations.last else {
            delegate?.gpsService(failedWithError: .locationUpdateError)
            return
        }
        
        delegate?.gpsServiceDidUpdate(location)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        delegate?.gpsService(failedWithError: .locationManagerFailedWith(error: error))
    }
}
