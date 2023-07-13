//
//  WeatherAppSnapshotTests.swift
//  WeatherAppSnapshotTests
//
//  Created by Catherine Shing on 7/13/23.
//

import SnapshotTesting
import XCTest
@testable import WeatherApp

class MyViewControllerTests: XCTestCase {
    
    var weatherViewController: WeatherViewController!
    
    override func setUp() {
        super.setUp()
        
        let weatherService: WeatherService = APIManager()
        let weatherViewModel = WeatherViewModel(weatherService: weatherService)
        weatherViewController = WeatherViewController(weatherViewModel: weatherViewModel)
    }
    
    override func tearDown() {
        weatherViewController = nil
        super.tearDown()
    }
    
    func testWeatherViewController() {
        setUp()
        
        assertSnapshot(matching: weatherViewController, as: .image)
    }
    
    func testWeatherViewController_DeviceVariations() {
        setUp()
        
        let devices: [String] = ["iPhone SE", "iPhone X"]
        
        for device in devices {
            assertSnapshot(matching: weatherViewController, as: .image, named: device)
        }
    }
    
    func testWeatherViewController_DarkMode() {
        setUp()
        
        UIView.appearance().overrideUserInterfaceStyle = .dark
        
        assertSnapshot(matching: weatherViewController, as: .image)
    }
}
