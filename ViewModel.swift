//
//  ViewModel.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 09/05/2024.
//

import Foundation
import AvioBook
import SwiftUI
import OSLog

@MainActor
class ViewModel: ObservableObject {
    
    let avioBook = AvioBook()
    let userDefaults = UserDefaults.standard
    
    @Published var showHabileLogin: Bool = false
    @AppStorage(UserDefaults.klmID) var klmID: String?
    @AppStorage(UserDefaults.userName) var userName: String?
    
    
    init() {
        initFunction()
    }
    
    
    func inspectCookies() async {
        
        print("-----HTTPCookieStorage----")
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                
                print("\(cookie.name): \(cookie.value.suffix(15)) \(cookie.expiresDate?.formatted() ?? "")")
            }
            
        }
    }
    
    func initFunction() {
        Task {
            let userDetails = await getUserDetails()
            userName = userDetails?.credentials.username
            Logger.viewModel.debug("Username: \(self.userName ?? "")")
            klmID = userDetails?.id
            Logger.viewModel.debug("KLM ID  : \(self.klmID ?? "")")
        }
    }
    
    func getUserDetails() async -> AvioBookUserDetails? {
        do {
            let userDetails = try await avioBook.getUserDetails()
            
            // Set Username
            
            return userDetails
        } catch AvioBookError.showHabile {
            showHabileLogin.toggle()
        } catch {
            print(error)
        }
        return nil
    }
    
    func getWeather() async -> AvioBookWeatherRoot? {
        do {
            return try await avioBook.getWeather(airports: ["EHAM", "EBBR"])
        } catch AvioBookError.showHabile {
            showHabileLogin.toggle()
        } catch {
            print(error)
        }
        return nil
    }
    
    func getFlightByID(_ id: String) async -> AvioBookFlightItem? {
        do {
            return try await avioBook.getFlightPlan(id: id)
        } catch {
            print(error)
        }
        return nil
    }
    
    func getDefaultFlights() async -> [AvioBookScheduleItem] {
        do {
            return try await avioBook.getDefaultFlights().items
        } catch AvioBookError.showHabile {
            showHabileLogin.toggle()
        } catch {
            print(error)
        }
        return []
    }
    
    func searchFlight(query: String) async -> [AvioBookScheduleItem] {
        do {
            return try await avioBook.flightSearch(query: query).items
        } catch AvioBookError.unauthorized {
            showHabileLogin.toggle()
        } catch {
            print(error)
        }
        return []
    }
}
