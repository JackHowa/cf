//
//  WeatherCardView.swift
//  cf
//
//  Created by Jack Howard on 8/3/25.
//
import SwiftUI

struct WeatherCardView: View {
    let city: String
    let temperatureF: String
    let temperatureC: String

    var body: some View {
        VStack(spacing: 16) {
            Text(city)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                VStack {
                    Text("Celsius")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(temperatureC)
                        .font(.system(size: 48, weight: .bold))
                }

                VStack {
                    Text("Fahrenheit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(temperatureF)
                        .font(.system(size: 48, weight: .bold))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(uiColor: .secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
                .shadow(radius: 10)
        )
        .padding(.horizontal)
    }
}
