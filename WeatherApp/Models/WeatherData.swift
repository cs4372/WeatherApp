//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import Foundation

struct WeatherData: Equatable, Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.name == rhs.name &&
        lhs.main == rhs.main &&
        lhs.weather == rhs.weather
    }
}

struct Main: Equatable, Decodable {
    let temp: Double
    let minTemp: Double
    let maxTemp: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

struct Weather: Equatable, Decodable {
    let description: String
    let id: Int
}
