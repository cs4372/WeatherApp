//
//  ServiceError.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/5/23.
//

import Foundation

struct ServiceError: Decodable {
    let cod: Int
    let message: String
}
