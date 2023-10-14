//
//  ContentView.swift
//  weatherApp
//
//  Created by Sven Güttner on 15.10.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherManager = WeatherNetworkManager.shared

    var body: some View {
        VStack {
            if let weatherData = weatherManager.weatherData {
                Text("City: \(weatherData.location.name)")
                Text("Region: \(weatherData.location.region)")
                Text("Country: \(weatherData.location.country)")
                Text("Temperature: \(weatherData.current.temp_c)°C")
                Text("Condition: \(weatherData.current.condition.text)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            // Immediately fetch data when the view appears
            self.weatherManager.fetchData(for: "Berlin") { data in
                DispatchQueue.main.async {
                    self.weatherManager.weatherData = data
                }
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
