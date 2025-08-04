//
//  ContentView.swift
//  cf
//
//  Created by Jack Howard on 8/3/25.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ContentView: View {
    @State private var temperatureF: String = "Loading..."
    @State private var temperatureC: String = "Loading..."

    let weatherService = WeatherService()
    let location = CLLocation(latitude: 31, longitude: 121)

    var body: some View {
        VStack(spacing: 20) {
            Text(temperatureF)
            Text(temperatureC)
        }
        .padding()
        .task {
            await fetchWeather()
        }
    }

    func fetchWeather() async {
        do {
            let weather = try await weatherService.weather(for: location)
            let temp = weather.currentWeather.temperature

            // Round to whole number
            let numberStyle = FloatingPointFormatStyle<Double>().precision(.fractionLength(0))

            let styleF = Measurement<UnitTemperature>.FormatStyle(
                width: .abbreviated,
                locale: Locale(identifier: "en_US"),
                usage: .weather,
                numberFormatStyle: numberStyle
            )

            let styleC = Measurement<UnitTemperature>.FormatStyle(
                width: .abbreviated,
                locale: Locale(identifier: "en_GB"),
                usage: .weather,
                numberFormatStyle: numberStyle
            )

            temperatureF = temp.converted(to: .fahrenheit).formatted(styleF)
            temperatureC = temp.converted(to: .celsius).formatted(styleC)

            print("F: \(temperatureF)")
            print("C: \(temperatureC)")

        } catch {
            temperatureF = "Error"
            temperatureC = "Error"
            print("Failed to get weather: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
