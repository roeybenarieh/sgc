//
//  SimulatorVC.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit

class SimulatorVC: UIViewController {
    
    //MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: IBAction
    
    @IBAction func ClickUp(_ sender: Any) {
        Bhelper.sendMessage(message:pressUp)
    }
    
    
    @IBAction func ClickMiddle(_ sender: Any) {
        Bhelper.sendMessage(message:pressMiddle)
    }
    
    
    @IBAction func ClickDown(_ sender: Any) {
        Bhelper.sendMessage(message:pressDown)
    }
    
    @IBAction func ClickWakeUp(_ sender: Any) {
        Bhelper.sendMessage(message:wakeUp)
    }
    
}
