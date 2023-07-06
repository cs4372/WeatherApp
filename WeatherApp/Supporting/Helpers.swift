//
//  Helpers.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/6/23.
//

import UIKit

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
    
    static func getWeatherIconName(for conditionId: Int) -> (name: String, backgroundColor: UIColor) {
        switch conditionId {
        case 200...232:
            return ("cloud.bolt", .systemGray)
        case 300...321:
            return ("cloud.drizzle", .systemGray)
        case 500...531:
            return ("cloud.rain", .systemGray)
        case 600...622:
            return ("snow", .systemBlue)
        case 701...781:
            return ("cloud.fog", .systemGray)
        case 800:
            return ("sun.max", .systemYellow)
        case 801...804:
            return ("cloud", .systemGray)
        default:
            return ("questionmark", .systemOrange)
        }
    }
}
