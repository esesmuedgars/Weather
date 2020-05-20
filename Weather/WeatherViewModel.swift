//
// Copyright © 2020 @esesmuedgars.
//

import Foundation

protocol WeatherViewModelType: class {}

final class WeatherViewModel: WeatherViewModelType {
    
    private let apiService: APIServiceProtocol
    private let gpsService: GPSServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService(),
         gpsService: GPSServiceProtocol = GPSService()) {
        self.apiService = apiService
        self.gpsService = gpsService
    }
}
