//
//  PrivacyPolicyViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 12.11.24.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    private var webView: WKWebView!
    private let urlString = "https://docs.google.com/document/d/10f50Wa9BMLyEfPpPiKPhXrZ2Uqhugy42nvs8OrWSr94/mobilebasic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
