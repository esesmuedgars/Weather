//
// Copyright © 2020 @esesmuedgars.
//

import XCTest
import CoreLocation
@testable import Weather

final class WeatherViewModelTests: XCTestCase {
    
    private var apiService: APIServiceMockProtocol!
    private var gpsService: GPSServiceMockProtocol!
    private var viewModel: WeatherViewModelType!
    
    override func setUp() {
        super.setUp()
                
        let apiService = APIServiceMock()
        self.apiService = apiService
        
        let gpsService = GPSServiceMock()
        self.gpsService = gpsService
        
        viewModel = WeatherViewModel(apiService: apiService,
                                     gpsService: gpsService)
    }
    
    override func tearDown() {
        viewModel = nil
        gpsService = nil
        apiService = nil
        
        super.tearDown()
    }

    func testRetrieveInitialCoordinate() {
        let expectation = self.expectation(
            description: "Expect GPSService to return expected value in delegate method."
        )
        
        let testLocation = CLLocation(
            latitude: .zero,
            longitude: .zero
        )
        
        gpsService.updatedLocation = testLocation
        
        viewModel.retrieveInitialCoordinate { coordinate in
            XCTAssertEqual(testLocation.coordinate.latitude, coordinate.latitude)
            XCTAssertEqual(testLocation.coordinate.longitude, coordinate.longitude)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testDidUpdateUserLocationSuccess() {
        let expectation = self.expectation(
            description: "Expect APIService to capture success result value in closure."
        )
        
        let testWeatherForecast = WeatherForecast(
            description: "Clear Day",
            icon: .clearDay,
            temperature: .zero
        )
        
        let coordinate = CLLocationCoordinate2D(
            latitude: .zero,
            longitude: .zero
        )
        
        apiService.fetchWeatherForecastResult = .success(testWeatherForecast)
        
        viewModel.didUpdateUserLocation(coordinate) { weatherForecast in
            XCTAssertEqual(testWeatherForecast.description, weatherForecast.description)
            XCTAssertEqual(testWeatherForecast.icon, weatherForecast.icon.rawValue)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testDidUpdateUserLocationFailure() {
        let expectation = self.expectation(
            description: "Expect APIService to capture failure result value in closure."
        )
        expectation.isInverted = true
        
        let coordinate = CLLocationCoordinate2D(
            latitude: .zero,
            longitude: .zero
        )
        
        apiService.fetchWeatherForecastResult = .failure(.emptyDataOrError)
        
        viewModel.didUpdateUserLocation(coordinate) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}

fileprivate extension WeatherForecast {
    init(latitude: Double = .zero,
         longitude: Double = .zero,
         description: String? = nil,
         icon: UIWeatherForecast.Icon,
         temperature: Double? = nil) {
        self = WeatherForecast(
            latitude: latitude,
            longitude: longitude,
            description: description,
            icon: icon.rawValue,
            temperature: temperature
        )
    }
}
