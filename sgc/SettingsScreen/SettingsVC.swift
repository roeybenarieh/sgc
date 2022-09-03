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
        changeButtonColor(color: UIColor.systemBlue)
        changeButtonText(text: "Connect to Dexcom account")
        let urlstr: String = "\(baseAuthenticationUrl)login?client_id=\(clientId)&redirect_uri=\(redirectUrl)&response_type=code&scope=offline_access&state=\(mystate)"
        webview.load(URLRequest(url: URL(string: urlstr)!))
        webview.navigationDelegate = self //telling the web view that this obj handle its navigation
    }
    
    
    //MARK: webview delegates
    //step three in dexcom api
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        if let url = navigationAction.request.url?.absoluteString{
            if url.hasPrefix(redirectUrl)
            {
                getCodeAndTokenFromRedirect(redirectUrl: url)
                
                var count = 0
                while(!hastoken){
                    Thread.sleep(forTimeInterval: 1)
                    count += 1
                    if(count >= 30){
                        changeButtonColor(color: UIColor.systemRed)
                        changeButtonText(text: "Error:api response timeout")
                    }
                }
                if hastoken{
                    changeButtonColor(color: UIColor.systemGreen)
                    changeButtonText(text: "Dexcom account connected")
                    
                    _ = Timer.scheduledTimer(timeInterval: 60 * 5, target: self, selector: #selector(getEVGs), userInfo: nil, repeats: true)
                }
                else{
                    changeButtonColor(color: UIColor.systemRed)
                    changeButtonText(text: "Error: try again")
                }
            }
        }
        decisionHandler(.allow)
    }
    @objc func getEVGs(){
        getGlucoseReadings(numberOfCurrentValues: 10)
    }
    
    //MARK: dexcom button properties
    public func changeButtonColor(color: UIColor){
        self.dexcomButton.backgroundColor = color
    }
    public func changeButtonText(text: String){
        self.dexcomButton.titleLabel?.text = text
    }
}
