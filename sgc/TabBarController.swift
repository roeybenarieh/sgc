//
//  TabBarControllerViewController.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit
import CoreBluetooth // used for CBPeripheral

class TabBarController: UITabBarController, BluetoothSerialDelegate {
    
    //MARK: IBInspectable
    
    /// a value that can be edited in the storyboard
    @IBInspectable var initialIndex: Int = 0 ///the first view that will be displayed
    
    //MARK: IBOutlet
    
    @IBOutlet weak var TabBar: UITabBar!
    
    
    //MARK: variables
    
    /// in simple words: hold the list of all of the found bluetooth modules
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    //TODO: change this from a list to a single value
    
    
    //MARK: UITabBarController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the view that initialy displayed
        selectedIndex = initialIndex
        
        // init serial, it takes a few seconde until the bluetooth is on and than the serialDidChangeState() func is called
        serial = BluetoothSerial(delegate: self)
    }
    
    
    //MARK: BluetoothSerialDelegate
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        print("discovered new peripheral")
        // check whether it is a duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        // add to the array, next sort & reload
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append((peripheral: peripheral, RSSI: theRSSI))
        peripherals.sort { $0.RSSI < $1.RSSI }
        
        if peripherals.count == 1{
            print("all2")
            //TODO: finish this
            //found a peripheral stop scanning
            serial.stopScan()
            // connect to the peripheral
            let selectedPeripheral = peripherals[0].peripheral
            serial.connectToPeripheral(selectedPeripheral)
            // making sure it is connected
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.connectTimeOut), userInfo: nil, repeats: false)
            //making the color of the tabbar green
            TabBar.backgroundColor = UIColor.systemGreen// your color
        }
    }
    
    /// called when CBCentralManager changes (e.g. when bluetooth is turned on/off)
    func serialDidChangeState() {
        print("bluetooth is turned on/off")
        if serial.centralManager.state == .poweredOn {
            // start scanning
            serial.startScan()
        }
        else{ ///Bluetooth is off
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
            dismiss(animated: true, completion: nil)
        }
    }
    /// Called when a peripheral disconnected
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        //TODO: finish this
        peripherals = []
        print("something disconnect")
    }

    
    //MARK: Functnions
    
    /// Should be called 10s after we've begun connecting
    @objc func connectTimeOut() {
        
        // don't if we've already connected
        if let _ = serial.connectedPeripheral {
            print("the connection is working good")
            return
        }
        print("bluetooth got disconnected after 10 seconds")
        //TODO: finish this
        /*
        if let _ = peripherals[0] {
            serial.disconnect()
            peripherals = []
        }
         */
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
