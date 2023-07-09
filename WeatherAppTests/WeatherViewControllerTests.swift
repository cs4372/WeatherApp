//
//  WeatherViewControllerTests.swift
//  WeatherAppTests
//
//  Created by Catherine Shing on 7/8/23.
//

import XCTest
@testable import WeatherApp

class WeatherViewControllerTests: XCTestCase {
    
    private var sut: WeatherViewController!
    private var weatherViewModel: MockWeatherViewModel!
    private var weatherService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        weatherService = MockWeatherService()
        weatherViewModel = MockWeatherViewModel(weatherService: weatherService)
        sut = WeatherViewController(weatherViewModel: weatherViewModel)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        weatherService = nil
        weatherViewModel = nil
        try super.tearDownWithError()
    }
    
    func testSetupUI() {
        // When
        sut.setupUI()
        
        // Assert
        XCTAssertNotNil(sut.rootStackView)
        XCTAssertNotNil(sut.topStackView)
        XCTAssertNotNil(sut.topWeatherStackView)
        XCTAssertNotNil(sut.bottomStackView)
        XCTAssertNotNil(sut.bottomWeatherTempInfoStackView)
        XCTAssertNotNil(sut.backgroundView)
        XCTAssertNotNil(sut.temperatureLabel)
        XCTAssertNotNil(sut.weatherDescriptionLabel)
        XCTAssertNotNil(sut.weatherImageView)
        XCTAssertNotNil(sut.bottomStackContainer)
        XCTAssertNotNil(sut.cityTextField)
        XCTAssertNotNil(sut.locationButton)
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertNotNil(sut.minTempLabel)
        XCTAssertNotNil(sut.maxTempLabel)
        XCTAssertNotNil(sut.humidityLabel)
    }
    
    func testFetchWeatherForCurrentLocation() {
        // When
        sut.updateWeatherData()
        
        // Assert
        XCTAssertTrue(weatherViewModel.fetchWeatherForCurrentLocationCalled)
    }
    
    func testLocationButtonClicked() {
        // When
        sut.locationButtonClicked()
        
        // Assert
        XCTAssertTrue(weatherViewModel.fetchWeatherForCurrentLocationCalled)
    }
    
    func testTextFieldShouldReturn_WithCityTextField_ShouldFetchWeatherData() {
        // Given
        let textField = sut.cityTextField
        textField.text = "London"

        // When clicks on return on the text field
        let result = sut.textFieldShouldReturn(textField)

        // Assert
        XCTAssertTrue(result)
        XCTAssertTrue(weatherViewModel.fetchWeatherDataCalled)
        XCTAssertEqual(weatherViewModel.fetchWeatherCity, "London")
    }
}

class MockWeatherViewModel: WeatherViewModel {
    private var mockWeatherData: WeatherData?
    var fetchWeatherForCurrentLocationCalled = false
    var fetchWeatherDataCalled = false
    var fetchWeatherCity: String?
    
    override var weatherData: WeatherData? {
        get {
            return mockWeatherData
        }
        set {
            mockWeatherData = nil
        }
    }
    
    override func fetchWeatherData(city: String) {
           fetchWeatherCity = city
           fetchWeatherDataCalled = true
       }
    
    override func fetchWeatherForCurrentLocation() {
        fetchWeatherForCurrentLocationCalled = true
    }
}
