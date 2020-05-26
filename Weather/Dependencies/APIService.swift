//
// Copyright © 2020 @esesmuedgars.
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case emptyDataOrError
    case unexpectedStatusCode(_ statusCode: Int)
    case unableToParseDataWith(error: Error)
}

extension APIServiceError {
    var description: String {
        switch self {
        case .invalidURL:
            return "Failed to construct URL."
        case .emptyDataOrError:
            return "Request did not fetch data or returned error."
        case .unexpectedStatusCode(let statusCode):
            return "Expected request status code between 200 - 299, received \(statusCode)."
        case .unableToParseDataWith(let error):
            return "Unable to parse data, with error: \(error)."
        }
    }
}

typealias Coordinate = (latitude: Double, longitude: Double)
typealias WeatherForecastCompletionBlock = (Result<WeatherForecast, APIServiceError>) -> Void

protocol APIServiceProtocol: class {
    func fetchWeatherForecast(coordinate: Coordinate,
                              completionHandler: @escaping WeatherForecastCompletionBlock)
}

final class APIService: APIServiceProtocol {
    
    // Replace editor placeholder with your Dark Sky `API Key` string
    private let apiKey: String = <#String#>
    
    func fetchWeatherForecast(coordinate: Coordinate,
                              completionHandler: @escaping WeatherForecastCompletionBlock) {
        guard let url = WeatherForecast.url(apiKey: apiKey, coordinate: coordinate) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        #if DEBUG
        print(url)
        #endif
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    completionHandler(.failure(.emptyDataOrError))
                    return
            }
            
            guard 200 ..< 300 ~= response.statusCode else {
                completionHandler(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            
            do {
                let weatherForecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                completionHandler(.success(weatherForecast))
            } catch {
                completionHandler(.failure(.unableToParseDataWith(error: error)))
            }
        }.resume()
    }
}
