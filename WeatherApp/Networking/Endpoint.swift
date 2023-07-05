//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import Foundation

enum Endpoint {
    
    case fetchWeather(url: String = "data/2.5/weather")
    
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
        case .fetchWeather(let url):
            return url
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .fetchWeather:
            return [
                URLQueryItem(name: "q", value: "london")
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
        switch endpoint {
        case .fetchWeather:
            self.setValue(Constants.API_KEY, forHTTPHeaderField: HTTP.Headers.Key.apiKey.rawValue)
        }
    }
}
