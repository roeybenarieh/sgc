//
//  SimulatorVC.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit
import AudioToolbox

class SimulatorVC: UIViewController {
    
    //MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: IBAction
    
    @IBAction func ClickUp(_ sender: Any) {
        Bhelper.sendMessage(message:pressUp)
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
    }
    
    
    @IBAction func ClickMiddle(_ sender: Any) {
        Bhelper.sendMessage(message:pressMiddle)
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
    }
    
    
    @IBAction func ClickDown(_ sender: Any) {
        Bhelper.sendMessage(message:pressDown)
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
    }
    
    @IBAction func ClickWakeUp(_ sender: Any) {
        Bhelper.sendMessage(message:wakeUp)
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
    }
    
}
