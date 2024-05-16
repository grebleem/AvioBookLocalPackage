//
//  WebViewHabile.swift
//  KneeBoard
//
//  Created by Bastiaan Meelberg on 23/10/2023.
//

import SwiftUI
import WebKit
import OSLog

@available(iOS 16.0.0, *)
struct WebviewHabile: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    let url: URL = URL(string: "https://avio.klm.com/idp/login?origin=https://avio.klm.com/idp/success&redirect=false")!
    
    func makeUIViewController(context: Context) -> WebviewController {
        let webviewController = WebviewController()
        
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webView.load(request)
        
        return webviewController
    }
    
    func updateUIViewController(_ webviewController: WebviewController, context: Context) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webView.load(request)
    }
}

class WebviewController: UIViewController, WKNavigationDelegate {
    lazy var webView: WKWebView = WKWebView()
    lazy var progressbar: UIProgressView = UIProgressView()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
        self.webView.navigationDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        webView.frame = .zero
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // We pin the web view to the safe area because some pages break otherwise.
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: webView.leftAnchor),
            view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: webView.rightAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: webView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let userdefault = UserDefaults.standard
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 1 {
                //Logger.webView.debug("Page loaded.")
                webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                    for cookie in cookies {
                        HTTPCookieStorage.shared.setCookie(cookie)
                        if cookie.name == "AVIO-Token" {
                            userdefault.set(cookie.value, forKey: UserDefaults.avioToken)
                            //self.viewModel.avioToken = cookie.value
                        }
                        if cookie.name == "AFKLM_PF_LOGINPRD" {
                            userdefault.set(cookie.value, forKey: UserDefaults.psn)
                        }
                    }
                }
                webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { html, _ in
                    if let htmlString = html as? String {
                        if htmlString.contains("Authentication was successful.") {
                            self.dismiss(animated: false)
                        }
                        // <div class="success-box">
                        if htmlString.contains("success-box") {
                            self.dismiss(animated: false)
                        }
                    }
                }
            }
        }
    }
}
