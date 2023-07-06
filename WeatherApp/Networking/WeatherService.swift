//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import Foundation

enum WeatherServiceError: Error {
//    case serverError(serviceError)
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
                    print(err.localizedDescription)
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
    
//    func parseJSON(weatherData: Data) -> WeatherModel? {
//        let decoder = JSONDecoder()
//        do {
//            let weatherData = try decoder.decode(WeatherData.self, from: weatherData)
//            guard let id = weatherData.weather.first?.id else { return nil }
//            let name = weatherData.name
//            let temp = weatherData.main.temp
//            guard let description = weatherData.weather.first?.description else { return nil }
//            let minTemp = weatherData.main.minTemp
//            let maxTemp = weatherData.main.maxTemp
//
//            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, weatherDescription: description, minTemp: minTemp, maxTemp: maxTemp)
//            print("weather", weather)
//            return weather
//        } catch {
//            return nil
//        }
//    }
}
