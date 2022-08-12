//
//  BluetoothHelper.swift
//  sgc
//
//  Created by roey ben arieh on 10/08/2022.
//

import Foundation
import CoreBluetooth

public let pressOk   = "0" , pressMiddle = "0"
public let pressUp   = "1"
public let wakeUp    = "2" , turnOn = "2"
public let pressDown = "3"

var Bhelper: BluetoothHelper!
class BluetoothHelper: BluetoothSerialDelegate{
    
    //MARK: variables
    
    /// list of all of the found bluetooth modules sorted by how well my device can hear it's signal (RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    var timer : Timer! = nil
    
    //MARK: initializer
    
    init(){
        // init serial, it takes a few seconde until the bluetooth is on and than the serialDidChangeState() func is called
        serial = BluetoothSerial(delegate: self)
    }
    
    
    //MARK: BluetoothSerialDelegate
    
    ///called when new peripheral is found
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        ///making sure this isn't duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        // add to the array, next sort
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append((peripheral: peripheral, RSSI: theRSSI))
        peripherals.sort { $0.RSSI < $1.RSSI }
        
        /// there is no connection to a bluetooth module
        if serial.connectedPeripheral == nil{
            // connect to the peripheral
            let selectedPeripheral = peripherals[0].peripheral
            serial.connectToPeripheral(selectedPeripheral)
            // making sure it's connected in every second for 15sec
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.connectTimeOut), userInfo: nil, repeats: true)
            //notify views that a new connection established
            notifyBluetoothConnectionChanged(connectedToBluetooth:"trying")
        }
    }
    
    ///called when a new message received, only happens when the arduino sends a confirmation of injection message
    func serialDidReceiveString(_ message: String){
        //ignore the message since its just the same confirmation string(no other messages are sent from the arduino)
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "InjectionConfirmation"), object: nil)
    }
    
    /// called when CBCentralManager changes (e.g. when bluetooth is turned on/off)
    func serialDidChangeState() {
        if serial.centralManager.state == .poweredOn {
            print("bluetooth is turned on")
            // start scanning
            serial.startScan()
        }
        else{ ///Bluetooth is off
            print("bluetooth is turned off, there is a problem")
        }
    }
    /// Called when a peripheral disconnected
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        //remove the disconnected peripheral from the list
        for index in 0...peripherals.count-1{
            if peripherals[index].peripheral.isEqual(peripheral){
                peripherals.remove(at: index)
                break
            }
        }
        notifyBluetoothConnectionChanged(connectedToBluetooth:"false")
        serial.startScan()
        print("something disconnected")
    }
    
    //MARK: functions
    
    var secondsPased: Int = 0
    ///Should be called 5s after we've begun connecting, it makes sure the connection is ok
    @objc func connectTimeOut() {
        secondsPased += 1
        // don't if we've already connected
        if serial.connectedPeripheral != nil && serial.isReady{
            notifyBluetoothConnectionChanged(connectedToBluetooth:"true")
            finishLoop()
        }
        else if secondsPased == 15{
            notifyBluetoothConnectionChanged(connectedToBluetooth:"false")
            serial.disconnect()
            serial.startScan()
            print("bluetooth got disconnected after 15 seconds")
            finishLoop()
        }
    }
    private func finishLoop(){
        secondsPased = 0
        timer.invalidate()
    }
    
    /// formating a notification post about a change in bluetooth connection
    private func notifyBluetoothConnectionChanged(connectedToBluetooth:String){
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Bluetoothchange"), object: nil, userInfo: ["connectedToBluetooth" : connectedToBluetooth])
    }
    
    ///sends message to the connected peripheral
    func sendMessage(message:String){
        if serial.isReady{
            serial.sendMessageToDevice(message)
        }
    }
    ///sends a formated injection message
    func sendInjection(amount:Int){
        sendMessage(message: "in" + String(amount))
    }
}
