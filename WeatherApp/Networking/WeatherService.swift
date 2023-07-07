//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import Foundation

enum WeatherServiceError: Error {
    case generalError(message: String)
    case decodingError(String = "Error parsing server response.")
}

class WeatherService {
    
    static func fetchWeather(with city: String, completion: @escaping (Result<WeatherData, WeatherServiceError>)->Void) {
        
        guard let request = Endpoint.fetchWeather(city: city).request else { return }
                        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                completion(.failure(.generalError(message: error.localizedDescription)))
                return
            }
            
            if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                
                do {
                    let weatherError = try JSONDecoder().decode(ServiceError.self, from: data ?? Data())
                    completion(.failure(.generalError(message: weatherError.message)))
                    
                } catch let err {
                    completion(.failure(.generalError(message: err.localizedDescription)))
                }
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(.success(weatherData))
                    
                } catch let err {
                    completion(.failure(.generalError(message: err.localizedDescription)))
                }
                
            }
        }.resume()
    }
}
