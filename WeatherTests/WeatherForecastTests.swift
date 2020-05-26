//
// Copyright © 2020 @esesmuedgars.
//

import XCTest
import Foundation
@testable import Weather

final class WeatherForecastTests: XCTestCase {
    
    func testWeatherForecastJSONDecoder() throws {
        let JSONString = """
        {
            "latitude": 59.33685,
            "longitude": 18.06237,
            "timezone": "Europe/Stockholm",
            "currently": {
                "time": 1590503064,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 19.99,
                "apparentTemperature": 19.99,
                "dewPoint": 4.02,
                "humidity": 0.35,
                "pressure": 1031.5,
                "windSpeed": 3.33,
                "windGust": 4.42,
                "windBearing": 188,
                "cloudCover": 0.43,
                "uvIndex": 2,
                "visibility": 16.093,
                "ozone": 360.3
            },
            "offset": 2
        }
        """
        
        guard let data = JSONString.data(using: .utf8) else {
            throw XCTestError(_nsError: NSError())
        }
        
        XCTAssertNoThrow(try JSONDecoder().decode(WeatherForecast.self, from: data))
    }
    
    func testWeatherForecastPartialJSONDecoder() throws {
        let JSONString = """
        {
            "latitude": 59.33685,
            "longitude": 18.06237,
            "timezone": "Europe/Stockholm"
        }
        """
        
        guard let data = JSONString.data(using: .utf8) else {
            throw XCTestError(_nsError: NSError())
        }
        
        XCTAssertNoThrow(try JSONDecoder().decode(WeatherForecast.self, from: data))
    }
    
    func testWeatherForecastPartialJSONDecoderThrows() throws {
        let expectation = self.expectation(
            description: "Expect JSONDecoder to throw error while decoding JSON with missing required values."
        )
        
        let JSONString = """
        {
            "latitude": 59.33685,
            "timezone": "Europe/Stockholm"
        }
        """
        
        guard let data = JSONString.data(using: .utf8) else {
            throw XCTestError(_nsError: NSError())
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(WeatherForecast.self, from: data)) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
