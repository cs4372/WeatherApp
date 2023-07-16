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

protocol WeatherService {
    func fetchWeather(with city: String) async throws -> WeatherData
}

class APIManager: WeatherService {
    func fetchWeather(with city: String) async throws -> WeatherData {
        guard let request = Endpoint.fetchWeather(city: city).request else {
            throw WeatherServiceError.generalError(message: "Invalid request")
        }
        
        do {
            let (data, resp) = try await URLSession.shared.data(for: request)
            
            if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                let serverErrorMessage = "Server responded with status code \(resp.statusCode)"
                throw WeatherServiceError.serverError(message: serverErrorMessage)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw WeatherServiceError.decodingError(error.localizedDescription)
        }
    }
}
