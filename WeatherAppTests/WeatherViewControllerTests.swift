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
    private var mockWeatherViewModel: MockWeatherViewModel!
    private var mockWeatherService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockWeatherViewModel = MockWeatherViewModel(weatherService: mockWeatherService)
        sut = WeatherViewController(weatherViewModel: mockWeatherViewModel)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockWeatherService = nil
        mockWeatherViewModel = nil
        try super.tearDownWithError()
    }
    
    func testSetupUI() {
        // When
        sut.setupUI()
        
        // Assert
        XCTAssertNotNil(sut.rootStackView)
        XCTAssertNotNil(sut.topStackView)
        XCTAssertNotNil(sut.bottomStackView)
        XCTAssertNotNil(sut.backgroundView)
        XCTAssertNotNil(sut.bottomStackContainer)
        XCTAssertNotNil(sut.locationButton)
    }
    
    func testFetchWeatherForCurrentLocation() {
        // When
        sut.updateWeatherData()
        
        // Assert
        XCTAssertTrue(mockWeatherViewModel.fetchWeatherForCurrentLocationCalled)
    }
    
    func testLocationButtonClicked() {
        // When
        sut.locationButtonClicked()
        
        // Assert
        XCTAssertTrue(mockWeatherViewModel.fetchWeatherForCurrentLocationCalled)
    }
    
    func testTextFieldShouldReturn() {
        // Given
        let textField = sut.bottomStackView.cityTextField
        textField.text = "London"
        let expectation = XCTestExpectation(description: "Fetch weather data")

        // When
        let result = sut.textFieldShouldReturn(textField)

        // Wait for fetchWeatherData to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        // Assert
        XCTAssertTrue(result)
        XCTAssertTrue(mockWeatherViewModel.fetchWeatherDataCalled)
        XCTAssertEqual(mockWeatherViewModel.fetchWeatherCity, "London")
    }
}

class MockWeatherViewModel: WeatherViewModel {
    private var mockWeatherData: WeatherData?
    var fetchWeatherForCurrentLocationCalled = false
    var fetchWeatherDataCalled = false
    var fetchWeatherCity: String?
    var fetchWeatherDataClosure: ((String) -> Void)?
    
    override func fetchWeatherData(city: String) async {
        fetchWeatherDataCalled = true
        fetchWeatherCity = city
    }
    
    override func fetchWeatherForCurrentLocation() {
        fetchWeatherForCurrentLocationCalled = true
    }
}
