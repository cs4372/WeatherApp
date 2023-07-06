//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
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

struct Weather: Decodable {
    let description: String
    let id: Int
}
