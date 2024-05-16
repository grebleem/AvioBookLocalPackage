//
//  WeatherView.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 10/05/2024.
//

import SwiftUI
import AvioBook

struct WeatherView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var weather: AvioBookWeatherRoot?
    
    var body: some View {
        ScrollView {
            if let items = weather?.items {
                LazyVStack {
                    ForEach(items) { airport in
                        WeatherItem(airport)
                    }
                }
                
            }
        }
        .task {
            weather = await viewModel.getWeather()
        }
    }
}

#Preview {
    @State var weather: AvioBookWeatherRoot = .sample
    return WeatherView(weather: weather)
        .environmentObject(ViewModel())
}
