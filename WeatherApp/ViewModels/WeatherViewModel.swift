//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import Foundation

class WeatherViewModel {
    
    private let weatherService: WeatherService
    
    var weatherData: WeatherData? {
           didSet {
               didUpdateWeatherData?()
           }
       }
    
    var didUpdateWeatherData: (() -> Void)?
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func fetchWeatherData(city: String) {
        WeatherService.fetchWeather(with: city) { result in
            switch result {
            case .success(let weatherData):
                print("weatherData ==>", weatherData)
                self.weatherData = weatherData
            case .failure(let error):
                print("error ==>", error)
            }
        }
    }
}
