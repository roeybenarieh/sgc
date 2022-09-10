//
//  TabBarControllerViewController.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit
import CoreBluetooth // used for CBPeripheral

class TabBarController: UITabBarController {
    
    //MARK: IBInspectable
    
    ///the first view that will be displayed
    @IBInspectable var initialIndex: Int = 0
    
    
    //MARK: UITabBarController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the view that initialy displayed
        selectedIndex = initialIndex
        
        //initializing the bluetooth helper class
        Bhelper = BluetoothHelper()
        //listen to when a bluetooth connection has changed
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothDisconnected(notification:)), name: NSNotification.Name.init(rawValue: "Bluetoothchange"), object: nil)
        
        dexcom = Dexcom(username: "roeyroey2", password: "ranran2424", outsideUSA: true)
        if #available(iOS 13, *) {
            scheduleBackgroundProcessing()
        }
    }

    
    //MARK: Functnions
    
    ///function that listen when a connection has changed and act accordingly
    @objc func bluetoothDisconnected(notification:NSNotification){
        if let info = notification.userInfo{
            let connected: String = info["connectedToBluetooth"] as! String
            if connected == "true"{
                changeTabBarColor(color:UIColor.systemGreen)
            }
            else if connected == "trying"{
                changeTabBarColor(color:UIColor.systemOrange)
            }
            else{ // =="false"
                changeTabBarColor(color:UIColor.systemRed)
            }
        }
    }
    
    public func changeTabBarColor(color:UIColor){
        self.tabBar.backgroundColor = color
    }
}
