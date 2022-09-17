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
    
    @IBOutlet weak var lastSchedule: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(injectionConfirmed(notification:)), name: NSNotification.Name.init(rawValue: "InjectionConfirmation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLastSchedule(notification:)), name: NSNotification.Name.init(rawValue: "doneSchedule"), object: nil)
    }

    @objc func injectionConfirmed(notification:NSNotification){
        //ignore the message, it has to be confirmation beacuse that's the only message type the arduino can send
        
        lastInjectionTime.text = "last Injection: " + getstrTime()
    }
    
    @objc func changeLastSchedule(notification:NSNotification){
        if let info = notification.userInfo{
            self.lastSchedule.text = info["text"] as? String
        }
    }
}

