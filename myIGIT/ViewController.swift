//
//  ViewController.swift
//  myIGIT
//
//  Created by Sambit Das on 27/01/1943 Saka.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    private func loadWebView() {
        let url = URL(string: "https://myigit.info")
        let requestObj = URLRequest(url: url! as URL)
        webView.load(requestObj)
    }
}

