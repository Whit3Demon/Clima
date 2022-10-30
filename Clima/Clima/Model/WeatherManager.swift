//
//  WeatherManager.swift
//  Clima
//
//  Created by Nikolai Kolmykov on 10.10.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
    
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1620b7af63a05a07eb240d7223402c21&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        perfomeReques(urlString: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        perfomeReques(urlString: urlString)
    }
    
    func perfomeReques(urlString: String){
        if let url = URL(string: urlString){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parsJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            task.resume()
            
        }
        
    }
    
    
    func parsJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let docodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            let weatherID = docodedData.weather[0].id
            let temp = docodedData.main.temp
            let name = docodedData.name
            
            let wetherModel = WeatherModel(conditionId: weatherID, cityName: name, temperature: temp)
            return wetherModel
            
            
        } catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
}

