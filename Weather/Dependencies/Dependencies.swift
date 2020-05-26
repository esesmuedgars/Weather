//
// Copyright © 2020 @esesmuedgars.
//

import Foundation

final class Dependencies {
    
    private(set) static var shared = Dependencies()
    
    let apiService: APIServiceProtocol
    let gpsService: GPSServiceProtocol
    
    private init() {
        apiService = APIService()
        gpsService = GPSService()
    }
}
