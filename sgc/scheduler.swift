//
//  injector.swift
//  sgc
//
//  Created by roey ben arieh on 11/09/2022.
//

import Foundation

let timeBetweenInjections = 50
let maxGlucose: Int = 130
let minGlucose: Int = 90
let insulinFuctor: Float = 10.0
let aimForMiddle: Bool = true
let targetGlucose = aimForMiddle ? (maxGlucose + minGlucose) / 2 : maxGlucose
var lastinjection = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!

var injectionScheduler: scheduler!
class scheduler {
    var injectionTimer: Timer! = nil
    
    init(){
        //listen to when a bluetooth connection has changed
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothconnected(notification:)), name: NSNotification.Name.init(rawValue: "Bluetoothchange"), object: nil)
    }

    @objc func handlerInjection(){
        print(dexcom.getLatestGlucoseReading()!.value)
    }
    
    ///function that listen when a connection has changed and act accordingly
    @objc func bluetoothconnected(notification:NSNotification){
        if let info = notification.userInfo{
            let connected: String = info["connectedToBluetooth"] as! String
            if connected == "true"{
                initializeTime()
            }
            else if connected == "trying"{
                injectionTimer = nil
            }
            else{ // =="false"
                injectionTimer = nil
            }
        }
    }
    func initializeTime(){
        injectionTimer = nil
        injectionTimer = Timer.scheduledTimer(timeInterval: 60 * 2.5, target: self, selector: #selector(self.handlerInjection), userInfo: nil, repeats: true)
    }
}

func getInjectionSuggestion() -> Int{
    let glucoseLevel = dexcom.getLatestGlucoseReading().value
    let diffComponents = Calendar.current.dateComponents([.minute], from: lastinjection, to: Date())
    if diffComponents.minute! < timeBetweenInjections{
        return 0
    }
    //checking for hypoglycemia - low suger value
    if glucoseLevel <= targetGlucose{
        return 0
    }
    return Int((Float)(glucoseLevel - targetGlucose) / insulinFuctor)
}
