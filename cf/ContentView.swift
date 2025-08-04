import SwiftUI
import WeatherKit
import CoreLocation

struct ContentView: View {
    @State private var temperatureF: String = "—"
    @State private var temperatureC: String = "—"
    @State private var cityName: String = "Locating…"
    @State private var hasFetchedWeather = false
    @StateObject private var locationManager = LocationManager()

    let weatherService = WeatherService()
    let geocoder = CLGeocoder()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                WeatherCardView(
                    city: cityName,
                    temperatureF: temperatureF,
                    temperatureC: temperatureC
                )
            }
            .padding()
        }
        .task {
            guard !hasFetchedWeather else { return }

            while locationManager.location == nil {
                try? await Task.sleep(nanoseconds: 300_000_000)
            }

            await fetchWeather()
            hasFetchedWeather = true
        }
    }

    func fetchWeather() async {
        guard let location = locationManager.location else { return }

        do {
            let weather = try await weatherService.weather(for: location)
            let temp = weather.currentWeather.temperature

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

            if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
                cityName = placemark.locality ?? "Unknown City"
            } else {
                cityName = "Unknown Location"
            }

        } catch {
            temperatureF = "Error"
            temperatureC = "Error"
            cityName = "Error"
        }
    }
}
