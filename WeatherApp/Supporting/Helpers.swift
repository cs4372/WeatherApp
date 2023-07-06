//
//  Helpers.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/6/23.
//

import Foundation

struct Helpers {
    static func convertKelvinToFahrenheit(kelvin: Double) -> Int {
        let fahrenheit = (kelvin - 273.15) * 9/5 + 32
        return Int(round(fahrenheit))
    }
    
    static func getTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: Date())
    }
    
    static func getWeatherIconName(for conditionId: Int) -> String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "questionmark"
        }
    }
}
