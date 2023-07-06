//
//  Constants.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import Foundation

struct Constants {
    
    // MARK: - API
    
    static let scheme = "https"
    static let baseURL = "api.openweathermap.org"
    static let port: Int? = nil
    static let fullURL = "https://api.openweathermap.org"
    
    static var API_KEY: String {
          if let path = Bundle.main.path(forResource: "APIKey", ofType: "plist") {
              if let keys = NSDictionary(contentsOfFile: path) as? [String: Any],
                  let apiKey = keys["WeatherAPIKey"] as? String {
                  return apiKey
              }
          }
          return ""
      }
}

