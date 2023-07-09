//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Catherine Shing on 7/8/23.
//

import XCTest
@testable import WeatherApp
import CoreLocation

final class WeatherViewModelTests: XCTestCase {
    
    private var sut: WeatherViewModel!
    private var mockWeatherService: MockWeatherService!

    override func setUpWithError() throws {
        mockWeatherService = MockWeatherService()
        sut = WeatherViewModel(weatherService: mockWeatherService)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockWeatherService = nil
        try super.tearDownWithError()
    }
    
    func testInitialization() {
        // Assert
        XCTAssertNotNil(sut, "The profile view model should not be nil.")
        XCTAssertTrue(sut.weatherService is MockWeatherService, "The weatherService should be equal to the weatherService that was passed in.")
    }
    
    func testFetchWeatherData_onAPISuccess() {
        // Given
        let city = "London"
        let weather = WeatherData(name: city, main: Main(temp: 12, minTemp: 20, maxTemp: 30, humidity: 80), weather: [Weather(description: "Very hot", id: 20)])
        mockWeatherService.fetchWeatherMockResult = .success(weather)
        
        // When
        sut.fetchWeatherData(city: city)
        
        // Assert
        XCTAssert(mockWeatherService.isFetchWeatherCalled)
        XCTAssertEqual(self.sut.weatherData, weather)
    }
    
    func testFetchWeatherData_onAPIFailure() {
        // Given
        let city = "London"
        let expectedError = WeatherServiceError.serverError(message: "Server error occurred")
        mockWeatherService.fetchWeatherMockResult = .failure(expectedError)
        
        // When
        sut.fetchWeatherData(city: city)
            
        // Assert
        sut.didDisplayError = { title, message in
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
        
        //Assert
        XCTAssertEqual(humidityString, "Humidity: 80")
    }
    
    func testImageIconName() {
        // Given
        let weather = WeatherData(name: "London", main: Main(temp: 12, minTemp: 20, maxTemp: 30, humidity: 80), weather: [Weather(description: "Sunny", id: 800)])
        sut.weatherData = weather
        
        // When
        let iconName = sut.weatherImageIconName
        
        // Assert
        XCTAssertEqual(iconName, "sun.max")
    }
    
    // checks if notifyDidUpdateWeatherData triggers the didUpdateWeatherData closure 
    func testNotifyDidUpdateWeatherData() {
        // Given
        let expectation = XCTestExpectation(description: "didUpdateWeatherData closure called")
        
        sut.didUpdateWeatherData = {
            expectation.fulfill()
        }
        
        // When
        sut.notifyDidUpdateWeatherData()
        
        // Assert to wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockWeatherService: WeatherService {
    var fetchWeatherMockResult: Result<WeatherData, WeatherServiceError>?
    var fetchWeatherCity: String?
    var isFetchWeatherCalled = false
    
    func fetchWeather(with city: String, completion: @escaping (Result<WeatherData, WeatherServiceError>) -> Void) {
        fetchWeatherCity = city
        isFetchWeatherCalled = true
        if let result = fetchWeatherMockResult {
            completion(result)
        }
    }
}

class MockCLLocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    var notifyDidUpdateWeatherDataCalled = false
    
    func notifyDidUpdateWeatherData() {
        notifyDidUpdateWeatherDataCalled = true
    }
}
