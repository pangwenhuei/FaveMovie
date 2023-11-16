//
//  WebView.swift
//  FaveMovie
//
//  Created by TTHQ23-PANGWENHUEI on 16/11/2023.
//

import Foundation
import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var error: Error?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        wkwebView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        wkwebView.load(request)
        return wkwebView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("loading error: \(error)")
            parent.isLoading = false
            parent.error = error
        }
        
//        func webView(_ webView: WKWebView,
//            didReceive challenge: URLAuthenticationChallenge,
//            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
//        {
//            if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
//            {
//                let serverTrust = challenge.protectionSpace.serverTrust!
//                let exceptions = SecTrustCopyExceptions(serverTrust)
//                SecTrustSetExceptions(serverTrust, exceptions)
//                let cred = URLCredential(trust: serverTrust)
//                completionHandler(.useCredential, cred)
//            }
//            else
//            {
//                completionHandler(.performDefaultHandling, nil)
//            }
//        }
        
    }
}
