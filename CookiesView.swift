//
//  CookiesView.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 10/05/2024.
//

import SwiftUI

struct CookiesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var cookies: [HTTPCookie]?
    
    var body: some View {
        Form {
            LazyVStack {
                if let cookies {
                    ForEach(cookies, id:\.self) { cookie in
                        LabeledContent(cookie.name, value: cookie.value.suffix(15))
                    }
                }
            }
        }
        .task {
            initiateBackgroundWork()
        }
    }
    
    func initiateBackgroundWork() {
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        let backgroundQueue = DispatchQueue(label: "background_queue",
                                            qos: .background)
        
        backgroundQueue.async {
            // Perform work on a separate thread at background QoS and
            // signal when the work completes.
            let cookies = HTTPCookieStorage.shared.cookies
           
           _ = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
           
           DispatchQueue.main.async {
               self.cookies = cookies
           }
        }
    }
}

#Preview {
    CookiesView()
}
