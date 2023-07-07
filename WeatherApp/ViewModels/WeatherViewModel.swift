//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import UIKit
import CoreLocation

class WeatherViewModel: NSObject, CLLocationManagerDelegate {
        
    private let weatherService: WeatherService
    private let locationManager = CLLocationManager()
    
    var weatherData: WeatherData? {
        didSet {
            notifyDidUpdateWeatherData()
        }
    }
    
    var city: String? {
        didSet {
            DispatchQueue.main.async {
                self.notifyDidUpdateCity()
            }
        }
    }
    
    // MARK: - Computed Properties for UI labels
    
    var temperatureString: String {
        let temperature = Helpers.convertKelvinToFahrenheit(kelvin: weatherData?.main.temp ?? 0.0)
        return "\(temperature)°F"
    }
    
    var weatherDescriptionString: String {
        return weatherData?.weather.first?.description ?? "Unknown"
    }
    
    var weatherImageIconName: String {
        return Helpers.getWeatherIconName(for: weatherData?.weather.first?.id ?? 0).name
    }
    
    var weatherImageIconColor: UIColor {
        return Helpers.getWeatherIconName(for: weatherData?.weather.first?.id ?? 0).backgroundColor
    }
    
    var cityTextFieldString: String {
        return weatherData?.name ?? "Enter city..."
    }
    
    var todayDateString: String {
        return Helpers.getTodayDate()
    }
    
    var minTempString: String {
        let minTemp = Helpers.convertKelvinToFahrenheit(kelvin: weatherData?.main.minTemp ?? 0)
        return "\(minTemp)°F"
    }
    
    var maxTempString: String {
        let maxTemp = Helpers.convertKelvinToFahrenheit(kelvin: weatherData?.main.maxTemp ?? 0)
        return "\(maxTemp)°F"
    }
    
    var humidityString: String {
        return "Humidity: \(weatherData?.main.humidity ?? 0)"
    }
    
    // MARK: - Callback closures to update UI
    
    var didUpdateWeatherData: (() -> Void)?
    var didUpdateCity: (() -> Void)?
        
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
        
    func fetchWeatherData(city: String) {
        WeatherService.fetchWeather(with: city) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.weatherData = weatherData
            case .failure(let error):
                print("Error fetching weather data:", error)
            }
        }
    }
    
    // MARK: - CLLocationManager to get current location

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first,
                  let city = placemark.locality else {
                return
            }
            
            self?.city = city
        }
    }
        
    private func notifyDidUpdateWeatherData() {
        DispatchQueue.main.async {
            self.didUpdateWeatherData?()
        }
    }
    
    private func notifyDidUpdateCity() {
        DispatchQueue.main.async {
            self.didUpdateCity?()
        }
    }
}
