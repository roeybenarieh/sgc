//
//  BluetoothHelper.swift
//  sgc
//
//  Created by roey ben arieh on 10/08/2022.
//

import Foundation
import CoreBluetooth

/// Global helper
let helper: BluetoothHelper! = BluetoothHelper()

final class BluetoothHelper{
    
    /// hold the list of all of the found bluetooth modules
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    
    /// Add new peripheral to the peripheral list
    func addPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?){ //MY ADDITION
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        // add to the array, next sort & reload
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append((peripheral: peripheral, RSSI: theRSSI))
        peripherals.sort { $0.RSSI < $1.RSSI }
    }
}
