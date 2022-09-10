//
//  SettingsVC.swift
//  sgc
//
//  Created by roey ben arieh on 08/08/2022.
//

import UIKit
import WebKit

class SettingsVC: UIViewController, WKNavigationDelegate {
    
    //MARK: IBOutlet variables
    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet public weak var dexcomButton: UIButton!
    
    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: IBAction button function
    //step two in dexcomp api
    @IBAction func openDexcomAuthenticationPage(){
        changeButtonColor(color: UIColor.systemBlue)
        changeButtonText(text: "Connect to Dexcom account")
        let urlstr: String = "https://google.com/"
        webview.load(URLRequest(url: URL(string: urlstr)!))
        webview.navigationDelegate = self //telling the web view that this obj handle its navigation
    }
    
    
    //MARK: webview delegates
    //step three in dexcom api
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        decisionHandler(.allow)
    }
    
    //MARK: dexcom button properties
    public func changeButtonColor(color: UIColor){
        self.dexcomButton.backgroundColor = color
    }
    public func changeButtonText(text: String){
        self.dexcomButton.titleLabel?.text = text
    }
}
