//
//  WeatherDataTests.swift
//  WeatherAppTests
//
//  Created by Catherine Shing on 7/8/23.
//

import XCTest
@testable import WeatherApp

final class WeatherDataTests: XCTestCase {
    
    func testParsingWeatherData() throws {
        let json = """
            {
              "weather": [
                {
                  "id": 800,
                  "description": "clear sky",
                }
              ],
              "main": {
                "temp": 10.58,
                "temp_min": 12.25,
                "temp_max": 18.25,
                "humidity": 80
              },
              "name": "London"
            }
           """
        
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let weatherData = try decoder.decode(WeatherData.self, from: jsonData)
        
        XCTAssertEqual(10.58, weatherData.main.temp)
        XCTAssertEqual(12.25, weatherData.main.minTemp)
        XCTAssertEqual(18.25, weatherData.main.maxTemp)
        XCTAssertEqual(80, weatherData.main.humidity)
        XCTAssertEqual("London", weatherData.name)
        XCTAssertEqual(800, weatherData.weather[0].id)
        XCTAssertEqual("clear sky", weatherData.weather[0].description)
    }
    
    func testParsingWeatherDataWithEmptyName() throws {
        let json = """
         {
           "weather": [
             {
               "id": 800,
               "description": "clear sky",
             }
           ],
            "main": {
                "temp": 10.58,
                "temp_min": 12.25,
                "temp_max": 18.25,
                "humidity": 80
             },
           "name": ""
         }
        """
        
        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)
        
        XCTAssertEqual("", weatherData.name)
    }
}
