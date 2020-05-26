//
// Copyright © 2020 @esesmuedgars.
//

import Foundation
import CoreLocation

typealias CoordinateUpdateBlock = (CLLocationCoordinate2D) -> Void
typealias WeatherForecastUpdateBlock = (UIWeatherForecast) -> Void

protocol WeatherViewModelType: class {
    func retrieveInitialCoordinate(coordinateUpdateBlock: @escaping CoordinateUpdateBlock)
    func didUpdateUserLocation(_ coordinate: CLLocationCoordinate2D,
                               updateBlock: @escaping WeatherForecastUpdateBlock)
}

final class WeatherViewModel: WeatherViewModelType {
    
    private let apiService: APIServiceProtocol
    private let gpsService: GPSServiceProtocol
    private var coordinateUpdateBlock: CoordinateUpdateBlock?
    
    init(apiService: APIServiceProtocol = Dependencies.shared.apiService,
         gpsService: GPSServiceProtocol = Dependencies.shared.gpsService) {
        self.apiService = apiService
        self.gpsService = gpsService
    }
    
    private func requestAuthorization() {
        gpsService.delegate = self
        gpsService.requestAuthorization()
    }
        
    private func fetchWeatherForecast(coordinate: Coordinate,
                                      updateBlock: @escaping WeatherForecastUpdateBlock) {
        apiService.fetchWeatherForecast(coordinate: coordinate) { result in
            switch result {
            case .success(let weatherForecast):
                guard let description = weatherForecast.description,
                    let rawValue = weatherForecast.icon,
                    let icon = UIWeatherForecast.Icon(rawValue: rawValue),
                    let temperature = weatherForecast.temperature else {
                        return
                }
                
                let measurementFormatter = MeasurementFormatter()
                measurementFormatter.unitOptions = .providedUnit
                measurementFormatter.numberFormatter.maximumFractionDigits = 0
                
                let measurement = Measurement(
                    value: temperature,
                    unit: UnitTemperature.celsius
                )
                
                let weatherForecast = UIWeatherForecast(
                    description: description,
                    icon: icon,
                    temperature: measurementFormatter.string(from: measurement)
                )
                
                DispatchQueue.main.async {
                    updateBlock(weatherForecast)
                }
                
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    // MARK: - WeatherViewModelType
    
    func retrieveInitialCoordinate(coordinateUpdateBlock: @escaping CoordinateUpdateBlock) {
        self.coordinateUpdateBlock = coordinateUpdateBlock
        
        requestAuthorization()
    }
    
    func didUpdateUserLocation(_ coordinate: CLLocationCoordinate2D,
                               updateBlock: @escaping WeatherForecastUpdateBlock) {
        let coordinate: Coordinate = (
            coordinate.latitude,
            coordinate.longitude
        )
        
        fetchWeatherForecast(coordinate: coordinate, updateBlock: updateBlock)
    }
}

extension WeatherViewModel: GPSServiceDelegate {
    func gpsServiceDidUpdate(_ location: CLLocation) {
        DispatchQueue.main.async {
            self.coordinateUpdateBlock?(location.coordinate)
        }
    }
    
    func gpsService(failedWithError error: GPSServiceError) {
        print(error.description)
    }
}
