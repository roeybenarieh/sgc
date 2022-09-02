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
        initHandler()
    }
    
    
    //MARK: IBAction button function
    //step two in dexcomp api
    @IBAction func openDexcomAuthenticationPage(){
        let urlstr: String = "\(baseAuthenticationUrl)login?client_id=\(clientId)&redirect_uri=\(redirectUrl)&response_type=code&scope=offline_access&state=\(mystate)"
        webview.load(URLRequest(url: URL(string: urlstr)!))
        webview.navigationDelegate = self //telling the web view that this obj handle its navigation
    }
    
    
    //MARK: webview delegates
    //step three in dexcom api
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        decisionHandler(.allow)
        if let url = navigationAction.request.url?.absoluteString{
            if url.hasPrefix(redirectUrl)
            {
                getCodeFromRedirect(redirectUrl: url)
                changeButtonColor(color: UIColor.systemGreen)
                changeButtonText(text: "Dexcom account connected")
            }
        }
    }
    
    //MARK: dexcom button properties
    public func changeButtonColor(color: UIColor){
        self.dexcomButton.tintColor = color
    }
    public func changeButtonText(text: String){
        self.dexcomButton.titleLabel?.text = text
    }
}
