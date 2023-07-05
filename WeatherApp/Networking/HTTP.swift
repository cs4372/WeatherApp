//
//  HTTP.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import Foundation

enum HTTP {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Headers {
        enum Key: String {
            case apiKey = "appid"
        }
    }
}

