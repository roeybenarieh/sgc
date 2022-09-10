//
//  injector.swift
//  sgc
//
//  Created by roey ben arieh on 11/09/2022.
//

import Foundation

let maxGlucose: Int = 130
let minGlucose: Int = 90
let insulinFuctor: Float = 10.0
let aimForMiddle: Bool = true
let targetGlucose = aimForMiddle ? (maxGlucose + minGlucose) / 2 : maxGlucose
var lastinjection = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!

func getInjectionSuggestion() -> Int{
    let glucoseLevel = dexcom.getLatestGlucoseReading().value
    let diffComponents = Calendar.current.dateComponents([.minute], from: lastinjection, to: Date())
    if diffComponents.minute! < 60{
        return 0
    }
    //checking for hypoglycemia
    if glucoseLevel <= targetGlucose{
        return 0
    }
    return Int((Float)(glucoseLevel - targetGlucose) / insulinFuctor)
}
