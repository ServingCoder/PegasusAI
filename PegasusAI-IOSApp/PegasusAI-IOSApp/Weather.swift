//
//  Weather.swift
//  PegasusAI-IOSApp
//
//  Created by Sandra Taskovic on 2025-03-09.
//  Edmonton Logitude and Latitde 53.5461° N, 113.4937° W

import Foundation

struct WeatherData: Codable {
    let visibility: Double
    let temperature: Double
    let uvIndex: Double
    let humidity: Double

    enum CodingKeys: String, CodingKey {
        case visibility = "visibility"
        case temperature = "temperature_2m"
        case uvIndex = "uv_index"
        case humidity = "relative_humidity_2m"
    }
}

struct WeatherResponse: Codable {
    let current: WeatherData
}

class WeatherService {
    
    func fetchWeather(for location: String, completion: @escaping (WeatherData?) -> Void) {
        print("inside1")
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=53.5461&longitude=-113.4938&current=visibility,temperature_2m,uv_index,relative_humidity_2m"
        
        guard let url = URL(string: urlString) else {
            print("inside2")
            completion(nil)
            return
        }
        
        print(url)

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("inside3")
                completion(nil)
                return
            }
            
            print(data)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Failed to convert data to string")
            }

            // Now decode the data to the structured format
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let weather = response.current
                
                // Print individual attributes
                print("Visibility: \(weather.visibility)")
                print("Temperature: \(weather.temperature)")
                print("UV Index: \(weather.uvIndex)")
                print("Humidity: \(weather.humidity)")
                
                completion(weather)
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

