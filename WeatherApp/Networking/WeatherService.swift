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
    case serverError(message: String)
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
                let serverErrorMessage = "Server responded with status code \(resp.statusCode)"
                completion(.failure(.serverError(message: serverErrorMessage)))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(.success(weatherData))
                    
                } catch let err {
                    completion(.failure(.decodingError(err.localizedDescription)))
                }
                
            }
        }.resume()
    }
}
