//
//  ViewController.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: IBOoutlets
    @IBOutlet weak var lastInjectionTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(injectionConfirmed(notification:)), name: NSNotification.Name.init(rawValue: "InjectionConfirmation"), object: nil)
    }

    @objc func injectionConfirmed(notification:NSNotification){
        //ignore the message, it has to be confirmation beacuse that's the only message type the arduino can send
        
        //formating the time:
        
        // 1. create the current date
        lastinjection = Date()
        // 2. Pick the date components
        let hours   = (Calendar.current.component(.hour, from: lastinjection))
        let minutes = (Calendar.current.component(.minute, from: lastinjection))
        // 3. Show the time
        lastInjectionTime.text = "last Injection: " + "\(hours):\(minutes)"
    }
}

