//
//  WatherData.swift
//  Clima
//
//  Created by Nikolai Kolmykov on 10.10.2022.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main : Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int
}
