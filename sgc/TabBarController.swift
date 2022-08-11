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
    }

    
    //MARK: Functnions
    
    ///function that listen when a connection has changed and act accordingly
    @objc func bluetoothDisconnected(notification:NSNotification){
        if let info = notification.userInfo{
            let connected: Bool = info["connectedToBluetooth"] as! Bool
            if connected{
                changeTabBarColor(color:UIColor.systemGreen)
            }
            else{
                changeTabBarColor(color:UIColor.systemRed)
            }
        }
    }
    
    public func changeTabBarColor(color:UIColor){
        self.tabBar.backgroundColor = color
    }
}
