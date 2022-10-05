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

var injectionHandler: injector!
class injector {
    
    init(){
        // get notifiction when a injection has confirmed
        NotificationCenter.default.addObserver(self, selector: #selector(injectionConfirmation(notification:)), name: NSNotification.Name.init(rawValue: "InjectionConfirmation"), object: nil)
    }

    func handlerInjection(){
        //telling the home screen that the scedule is now happening
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "doneSchedule"), object: nil, userInfo: ["text" : "last schedule: " + getstrTime()])
        let suggestion = getInjectionSuggestion()
        Bhelper.sendInjection(amount: suggestion)
    }
    
    //MARK: LISTENERS
    @objc func injectionConfirmation(notification:NSNotification){
        lastinjection = Date()
    }
    
    //MARK: FUNCTIONS
    func getInjectionSuggestion() -> Int{
        let diffComponents = Calendar.current.dateComponents([.minute], from: lastinjection, to: Date())
        //checking whether the minimum time between injection has passed
        if diffComponents.minute! < timeBetweenInjections{
            return 0
        }
        if let glucoseReading = dexcom.getLatestGlucoseReading(){
            let glucoseLevel = glucoseReading.value
            
            //checking for hypoglycemia - low suger value
            if glucoseLevel <= targetGlucose{
                return 0
            }
            //calculating the suggestion
            return Int((Float)(glucoseLevel - targetGlucose) / insulinFuctor)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "doneSchedule"), object: nil, userInfo: ["text" : "api error at " + getstrTime()])
            return 0
        }
    }
}

func getstrTime(date:Date = Date()) -> String{
    let df = DateFormatter()
    if Calendar.current.isDateInToday(date){
        df.dateFormat = "HH:mm"
    }
    else{
        df.dateFormat = "dd-MM-yyyy HH:mm"
    }
    return df.string(from: date)
}
