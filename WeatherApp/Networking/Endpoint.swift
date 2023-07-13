//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import Foundation

enum Endpoint {
    
    case fetchWeather(city: String)

    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        request.addValues(for: self)
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = Constants.port
        components.path = self.path
        components.queryItems = self.queryItems
        return components.url
    }
    
    private var path: String {
        switch self {
        case .fetchWeather:
            return "/data/2.5/weather"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        var constants = Constants()
        switch self {
        case .fetchWeather(let city):
            return [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: constants.API_KEY)
            ]
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .fetchWeather:
            return HTTP.Method.get.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .fetchWeather:
            return nil
        }
    }
}

extension URLRequest {
    
    mutating func addValues(for endpoint: Endpoint) {
        var constants = Constants()

        switch endpoint {
        case .fetchWeather:
            self.setValue(constants.API_KEY, forHTTPHeaderField: HTTP.Headers.Key.apiKey.rawValue)
        }
    }
}
