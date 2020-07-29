//
//  WeatheData.swift
//  ElClima
//
//  Created by Francisco Hernandez on 4/18/20.
//  Copyright © 2020 Francisco Hernandez. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
   // let description: String
    let id: Int
}
