//
//  FlightsView.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 10/05/2024.
//

import SwiftUI
import AvioBook

struct FlightsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var searchText: String = ""
    @State var flights: [AvioBookScheduleItem] = []
    
    var body: some View {
        FlightList(flights: flights, searchText: searchText)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search Flightnumber, ICAO"
            )
            .refreshable {
                flights = await viewModel.getDefaultFlights()
                
            }
            .autocorrectionDisabled()
            .onSubmit(of: .search) {
                Task {
                    flights = await viewModel.searchFlight(query: searchText)
                }
            }
    }
}

#Preview {
    FlightsView()
        .environmentObject(ViewModel())
}
