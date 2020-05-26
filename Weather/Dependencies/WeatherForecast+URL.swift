//
// Copyright © 2020 @esesmuedgars.
//

import Foundation

struct WeatherForecast {
    let latitude: Double
    let longitude: Double
    let description: String?
    let icon: String?
    let temperature: Double?
}

extension WeatherForecast: Decodable {
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        
        case nestedContainer = "currently"
        case description = "summary"
        case icon
        case temperature
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        
        let nestedContainer = try? container.nestedContainer(keyedBy: CodingKeys.self,
                                                             forKey: .nestedContainer)
        
        description = try nestedContainer?.decodeIfPresent(String.self, forKey: .description)
        icon = try nestedContainer?.decodeIfPresent(String.self, forKey: .icon)
        temperature = try nestedContainer?.decodeIfPresent(Double.self, forKey: .temperature)
    }
}

extension WeatherForecast {
    static func url(apiKey: String, coordinate: Coordinate) -> URL? {
        guard let url = URL(string: "https://api.darksky.net/forecast")?
            .appendingPathComponent(apiKey)
            .appendingPathComponent("\(coordinate.latitude),\(coordinate.longitude)") else {
                return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            .init(name: "exclude", value: "minutely,hourly,daily,alerts,flags"),
            .init(name: "units", value: "auto")
        ]
        
        return components?.url
    }
}
