//
//  FlightList.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 10/05/2024.
//

import SwiftUI
import AvioBook

struct FlightList: View {
    @EnvironmentObject var viewModel: ViewModel
    var flights: [AvioBookScheduleItem]
    var searchText: String
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(flights, id: \.id) { flight in
                    NavigationLink {
                        FlightPlanView(avioBookScheduleItem: flight)
                    } label: {
                        FlightRowItem(flight)
                    }
                }
            }
        }
    }
    
    private func FlightRowItem(_ flight: AvioBookScheduleItem) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(flight.flightNumber)
                    .font(.headline)
                Spacer()
                if let std = flight.schedule?.std {
                    Text(std, format: .dateTime)
                }
            }
            HStack {
                Text(flight.departure?.airport.icao ?? "")
                Text(flight.destination?.airport.icao ?? "")
            }
            if let status = flight.ofps?.first {
                HStack {
                    Text(status.status)
                    Spacer()
                    Text(status.release)
                }
                .font(.subheadline)
            .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        
        .background(.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationStack {
        FlightList(flights: AvioBookScheduleRoot.sample.items, searchText: "")
    }
}
