//
// Copyright © 2020 @esesmuedgars.
//

@testable import Weather

protocol APIServiceMockProtocol: class {
    var fetchWeatherForecastResult: Result<WeatherForecast, APIServiceError>? { get set }
}

final class APIServiceMock: APIServiceMockProtocol, APIServiceProtocol {
    
    var fetchWeatherForecastResult: Result<WeatherForecast, APIServiceError>?
    
    // MARK: - APIServiceProtocol
    
    func fetchWeatherForecast(coordinate: Coordinate,
                              completionHandler: @escaping WeatherForecastCompletionBlock) {
        guard let result = fetchWeatherForecastResult else {
            return
        }
         
        completionHandler(result)
    }
}
