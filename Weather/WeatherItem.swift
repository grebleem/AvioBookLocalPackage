//
//  WeatherItem.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 10/05/2024.
//

import SwiftUI
import AvioBook

struct WeatherItem: View {
    var item: AvioBookWeatherItem
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(item.icao)
                    .font(.headline)
                Spacer()
                AvioBookWeatherFlightRuleLabel(flightRule: item.weather.parsedMetar.flightRule)
            }
            HStack {
                Text(item.weather.parsedMetar.issuedAt, format: .dateTime)
                Spacer()
                Text(item.weather.parsedMetar.issuedAt, style: .offset)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            Text(item.weather.metar)
                .font(AvioFont.monoSmall)
            Text(item.weather.ftTaf)
                .font(AvioFont.monoSmall)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    init(_ item: AvioBookWeatherItem) {
        self.item = item
    }
}

#Preview {
    WeatherItem(AvioBookWeatherItem.sampleItem)
}
