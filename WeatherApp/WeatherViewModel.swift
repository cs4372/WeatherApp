//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import UIKit
import CoreLocation

class WeatherViewModel: NSObject, CLLocationManagerDelegate {
    
    internal let weatherService: WeatherService
    internal let locationManager = CLLocationManager()
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    var weatherData: WeatherData? {
        didSet {
            notifyDidUpdateWeatherData()
        }
    }
    
    // MARK: - Callback closures to update UI
    
    var didUpdateWeatherData: (() -> Void)?
    var didDisplayError: ((String, String) -> Void)?
    
    // MARK: - Computed Properties for UI labels
    
    var temperatureString: String {
        let temperature = Helpers.convertKelvinToFahrenheit(kelvin: weatherData?.main.temp ?? 0.0)
        return "\(temperature)°F"
    }
    
    var weatherDescriptionString: String {
        let weatherDescription = weatherData?.weather.first?.description ?? "Unknown"
        let weatherDescriptionLocalizedString = NSLocalizedString(weatherDescription, comment: "Weather description")
        return weatherDescriptionLocalizedString
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
        let minTempVal = Helpers.convertKelvinToFahrenheit(kelvin: weatherData?.main.minTemp ?? 0)
        let minTempLocalizedString = NSLocalizedString("L", comment: "Lowest temperature label")
        return "\(minTempLocalizedString): \(minTempVal)°F"
    }
    
    var maxTempString: String {
        let maxTempVal = Helpers.convertKelvinToFahrenheit(kelvin: weatherData?.main.maxTemp ?? 0)
        let maxTempLocalizedString = NSLocalizedString("H", comment: "Highest temperature label")
        return "\(maxTempLocalizedString): \(maxTempVal)°F"
    }
    
    var humidityString: String {
        let humidityValue = weatherData?.main.humidity ?? 0
        let humidityLocalizedString = NSLocalizedString("Humidity", comment: "Humidity label")
        return "\(humidityLocalizedString): \(humidityValue)"
    }
    
    func fetchWeatherForCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchWeatherData(city: String) async {
         do {
             let weatherData = try await weatherService.fetchWeather(with: city)
             self.weatherData = weatherData
         } catch let error as WeatherServiceError {
             let errorMessage = handleError(error)
             let titleMessage = "Please try again!"
             didDisplayError?(titleMessage, errorMessage)
         } catch {
             print("An error occurred: \(error)")
         }
     }
    
    private func handleError(_ error: WeatherServiceError) -> String {
        switch error {
        case .generalError(let message):
            return "Error occurred: \(message)"
        case .decodingError(let message):
            print("decodingError error", message)
            return "Error parsing server response: \(message)"
        case .serverError(let message):
            print("server error", message)
            return "An error occurred on the server."
        }
    }
    
    // MARK: - CLLocationManager to get current location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let geocoder = CLGeocoder()
        Task {
            do {
                if let placemarks = try await geocoder.reverseGeocodeLocation(location).first {
                    if let city = placemarks.locality {
                        await fetchWeatherData(city: city)
                    }
                }
            } catch {
                print("Geocoding error: \(error)")
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    internal func notifyDidUpdateWeatherData() {
        DispatchQueue.main.async {
            self.didUpdateWeatherData?()
        }
    }
}
