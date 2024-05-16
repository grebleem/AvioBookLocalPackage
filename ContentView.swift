//
//  ContentView.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 09/05/2024.
//

import SwiftUI
import AvioBook

struct ContentView: View {
    @State var userDetails: AvioBookUserDetails?
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink("Weather", destination: {
                    WeatherView()
                })
                NavigationLink("Cookies", destination: {
                    CookiesView()
                })
                NavigationLink("Flights", destination: {
                    FlightsView()
                })
                if let userDetails {
                    LabeledContent("First Name", value: userDetails.firstName)
                    LabeledContent("Last Name", value: userDetails.lastName)
                    LabeledContent("ID", value: userDetails.id)
                    LabeledContent("User Name", value: userDetails.credentials.username)
                }
                Button("User") {
                    Task {
                        userDetails = await viewModel.getUserDetails()
                    }
                }
                .buttonStyle(.borderedProminent)
                if viewModel.showHabileLogin {
                    Text("HABILE")
                }
                
                flightRadar
            }
            .navigationTitle("AvioBook Test")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showHabileLogin) {
                WebviewHabile()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Login", systemImage: "shield.righthalf.filled") {
                        viewModel.showHabileLogin.toggle()
                    }
                }
            }
        }
    }
    
    var flightRadar: some View {
        Section("FlightRadar24") {
            if let url = URL(string: "se.resenatverket.FlightRadar24-Free://search=PHBXA") {
                Link("FR24", destination: url)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
