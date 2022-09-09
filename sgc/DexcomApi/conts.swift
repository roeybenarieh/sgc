//
//  conts.swift
//  sgc
//
//  Created by roey ben arieh on 09/09/2022.
//

import Foundation

// Dexcom Share API base urls
let DEXCOM_BASE_URL = "https://share2.dexcom.com/ShareWebServices/Services"
let DEXCOM_BASE_URL_OUS = "https://shareous1.dexcom.com/ShareWebServices/Services"

// Dexcom Share API endpoints
let DEXCOM_LOGIN_ID_ENDPOINT = "General/LoginPublisherAccountById"
let DEXCOM_AUTHENTICATE_ENDPOINT = "General/AuthenticatePublisherAccount"
let DEXCOM_VERIFY_SERIAL_NUMBER_ENDPOINT = (
    "Publisher/CheckMonitoredReceiverAssignmentStatus"
)
let DEXCOM_GLUCOSE_READINGS_ENDPOINT = "Publisher/ReadPublisherLatestGlucoseValues"

let DEXCOM_APPLICATION_ID = "d89443d2-327c-4a6f-89e5-496bbb0317db"

// Dexcom error strings
let ACCOUNT_ERROR_USERNAME_NULL_EMPTY = "Username null or empty"
let ACCOUNT_ERROR_PASSWORD_NULL_EMPTY = "Password null or empty"
let SESSION_ERROR_ACCOUNT_ID_NULL_EMPTY = "Accound ID null or empty"
let SESSION_ERROR_ACCOUNT_ID_DEFAULT = "Accound ID default"
let ACCOUNT_ERROR_ACCOUNT_NOT_FOUND = "Account not found"
let ACCOUNT_ERROR_PASSWORD_INVALID = "Password not valid"
let ACCOUNT_ERROR_MAX_ATTEMPTS = "Maximum authentication attempts exceeded"
let ACCOUNT_ERROR_UNKNOWN = "Account error"

let SESSION_ERROR_SESSION_ID_NULL = "Session ID null"
let SESSION_ERROR_SESSION_ID_DEFAULT = "Session ID default"
let SESSION_ERROR_SESSION_NOT_VALID = "Session ID not valid"
let SESSION_ERROR_SESSION_NOT_FOUND = "Session ID not found"

let ARGUEMENT_ERROR_MINUTES_INVALID = "Minutes must be between 1 and 1440"
let ARGUEMENT_ERROR_MAX_COUNT_INVALID = "Max count must be between 1 and 288"
let ARGUEMENT_ERROR_SERIAL_NUMBER_NULL_EMPTY = "Serial number null or empty"


// let Other
let DEXCOM_TREND_DESCRIPTIONS = [
    "",
    "rising quickly",
    "rising",
    "rising slightly",
    "steady",
    "falling slightly",
    "falling",
    "falling quickly",
    "unable to determine trend",
    "trend unavailable"
]

var DEXCOM_TREND_DIRECTIONS: [String:Int] = [
    "None": 0,
    "DoubleUp": 1,
    "SingleUp": 2,
    "FortyFiveUp": 3,
    "Flat": 4,
    "FortyFiveDown": 5,
    "SingleDown": 6,
    "DoubleDown": 7,
    "NotComputable": 8,
    "RateOutOfRange": 9
]

let DEXCOM_TREND_ARROWS = ["", "↑↑", "↑", "↗", "→", "↘", "↓", "↓↓", "?", "-"]

let DEFAULT_SESSION_ID = "00000000-0000-0000-0000-000000000000"

let MMOL_L_CONVERTION_FACTOR = 0.0555


