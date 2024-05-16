//
//  AvioBookPackageLocalApp.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 09/05/2024.
//

import SwiftUI
import AvioBook

@main
struct AvioBookPackageLocalApp: App {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
