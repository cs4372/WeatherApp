//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Catherine Shing on 7/8/23.
//

import XCTest
@testable import WeatherApp


final class WeatherViewModelTests: XCTestCase {
    
    private var sut: WeatherViewModel!
    private var weatherService: MockWeatherService!

    override func setUpWithError() throws {
        weatherService = MockWeatherService()
        sut = WeatherViewModel(weatherService: weatherService)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        weatherService = nil
        try super.tearDownWithError()
    }
    
    func testFetchWeatherData_onAPISuccess() {
        // Given
        let city = "London"
        let weather = WeatherData(name: city, main: Main(temp: 12, minTemp: 20, maxTemp: 30, humidity: 80), weather: [Weather(description: "Very hot", id: 20)])
        weatherService.fetchWeatherMockResult = .success(weather)

        // When
        sut.fetchWeatherData(city: city)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.sut.weatherData, weather)
        }
    }
    
    func testFetchWeatherData_onAPIFailure() {
        // Given
        let city = "London"
        let expectedError = WeatherServiceError.serverError(message: "Server error occurred")
        weatherService.fetchWeatherMockResult = .failure(expectedError)
        
        // When
        sut.fetchWeatherData(city: city)
                
        sut.didDisplayError = { title, message in
            // Then
            XCTAssertEqual(title, "Please try again!")
            XCTAssertEqual(message, expectedError.localizedDescription)
        }
    }
    
    func testHumidityString() {
        // Given
        let weather = WeatherData(name: "London", main: Main(temp: 12, minTemp: 20, maxTemp: 30, humidity: 80), weather: [Weather(description: "Sunny", id: 800)])
        sut.weatherData = weather
        
        // When
        let humidityString = sut.humidityString
        
        // Then
        XCTAssertEqual(humidityString, "Humidity: 80")
    }
    
    func testImageIconName() {
        // Given
        let weather = WeatherData(name: "London", main: Main(temp: 12, minTemp: 20, maxTemp: 30, humidity: 80), weather: [Weather(description: "Sunny", id: 800)])
        sut.weatherData = weather
        
        // When
        let iconName = sut.weatherImageIconName
        
        // Then
        XCTAssertEqual(iconName, "sun.max")
    }
}

class MockWeatherService: WeatherService {
    var fetchWeatherMockResult: Result<WeatherData, WeatherServiceError>?
    var fetchWeatherCity: String?

    func fetchWeather(with city: String, completion: @escaping (Result<WeatherData, WeatherServiceError>) -> Void) {
        fetchWeatherCity = city
        if let result = fetchWeatherMockResult {
            completion(result)
        }
    }
}
