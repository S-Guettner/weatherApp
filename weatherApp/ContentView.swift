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
    
    var temperature: Int {
        if let weatherData = weatherManager.weatherData {
            return Int(weatherData.current.temp_c)
        } else {
            return 0
        }
    }

    
    //Body
    var body: some View {
        HStack{
            VStack {
                AsyncImage(url: URL(string: "https://source.unsplash.com/random/250x250/?\(city)"), scale: 1) { phase in
                    switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 370, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                
                                
                        case .failure(_):
                            ProgressView()
                            .frame(width: 250, height: 250)
                        case .empty:
                            ProgressView() // Loading indicator
                        @unknown default:
                            ProgressView() // A generic loading indicator for unknown cases
                    }
                }
                Spacer()




                    
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
                    Text("\(weatherData.location.name)")
                    Text("\(weatherData.location.country)")
                    Text("\(temperature)°C")
                    Text("Condition: \(weatherData.current.condition.text)")
                } else {
                    Text("Loading...")
                }
            }

            .padding()
        }
        .frame(height: 500)
        }
        

}
#Preview {
    ContentView()
}
