//
//  ViewController.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit

var MinutesToScheduleWarning = 1 //this var represent when the app tell the user a long time has passed from last schedule
class HomeVC: UIViewController {
    
    //MARK: IBOoutlets
    @IBOutlet weak var lastInjection: UILabel!
    
    @IBOutlet weak var lastSchedule: UILabel!
    
    
    //MARK: Variables
    var lastScheduleTime: Date! = Date()
    
    
    //MARK: Viewcontroller datasource
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(injectionConfirmed(notification:)), name: NSNotification.Name.init(rawValue: "InjectionConfirmation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLastSchedule(notification:)), name: NSNotification.Name.init(rawValue: "doneSchedule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    @objc func didBecomeActive() {
        let diffComponents = Calendar.current.dateComponents([.minute], from: lastScheduleTime, to: Date())
        //checking whether the minimum time between injection has passed
        if diffComponents.minute! > MinutesToScheduleWarning{
            lastSchedule.textColor = UIColor.systemRed
        }
        else{
            lastSchedule.textColor = UIColor.systemGreen
        }
    }

    @objc func injectionConfirmed(notification:NSNotification){
        //ignore the message, it has to be confirmation beacuse that's the only message type the arduino can send
        
        if let info = notification.userInfo{
            let amount = info["injectionAmount"] as! Int
            
            //making the ui change only in the main thread!!
            DispatchQueue.main.async { [weak self] in
                self?.lastInjection.text = "last Injection: " + getstrTime() + " - " + injectionIntegetToString(amount: amount)
            }
        }
    }
    
    @objc func changeLastSchedule(notification:NSNotification){
        lastScheduleTime = Date()
        if let info = notification.userInfo{
            //making the ui change only in the main thread!!
            DispatchQueue.main.async { [weak self] in
                self?.lastSchedule.textColor = UIColor.systemGreen
                self?.lastSchedule.text = (info["text"] as? String)! + getstrTime(date: self!.lastScheduleTime)
            }
        }
    }
}

