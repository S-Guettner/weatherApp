import Foundation
import Combine

class WeatherNetworkManager: ObservableObject { // Conform to ObservableObject
    
    static let shared = WeatherNetworkManager()
    
    @Published var weatherData: WeatherData? // Add @Published to properties that should trigger updates
    
    
    
    struct WeatherData: Codable {
        var location: Location
        var current: CurrentWeather
    }

    struct Location: Codable {
        var name: String
        var region: String
        var country: String
    }

    struct CurrentWeather: Codable {
        var temp_c: Double
        var condition: Condition
    }

    struct Condition: Codable {
        var text: String
        var icon: String
    }
    
    func fetchData(for city: String, completion: @escaping (WeatherData?) -> Void) {
        if let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=7a423cfefcf34dff85e222625231410&q=/\(city)&aqi=no") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(WeatherData.self, from: data)
                        
                        print(decodedData)
                        
                        // Update the @Published property to trigger view updates
                        DispatchQueue.main.async {
                            self.weatherData = decodedData
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}
