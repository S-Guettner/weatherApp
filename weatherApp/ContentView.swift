//
//  ContentView.swift
//  weatherApp
//
//  Created by Sven Güttner on 15.10.23.
//

import SwiftUI

struct ContentView: View {
    //Variables
    @ObservedObject var weatherManager = WeatherNetworkManager.shared
    @State private var city: String = "Berlin"
    
    //Body
    var body: some View {
        VStack {
            
            HStack {
                TextField("City", text: $city)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .cornerRadius(10)
                    .onChange(of: city, initial: true) {
                        self.weatherManager.fetchData(for: city) { data in
                            DispatchQueue.main.async {
                                self.weatherManager.weatherData = data
                            }
                        }
                    }

            }
            .foregroundColor(.black)
            
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

        .padding()
    }
}
#Preview {
    ContentView()
}
