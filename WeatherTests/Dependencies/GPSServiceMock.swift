//
// Copyright © 2020 @esesmuedgars.
//

import CoreLocation
@testable import Weather

protocol GPSServiceMockProtocol: class {
    var updatedLocation: CLLocation? { get set }
}

final class GPSServiceMock: GPSServiceMockProtocol, GPSServiceProtocol {
    
    var updatedLocation: CLLocation?
    
    // MARK: - GPSServiceProtocol
    
    var delegate: GPSServiceDelegate?
    
    func requestAuthorization() {
        guard let location = updatedLocation else {
            delegate?.gpsService(failedWithError: .locationServicesDisabled)
            return
        }
        
        delegate?.gpsServiceDidUpdate(location)
    }
}
