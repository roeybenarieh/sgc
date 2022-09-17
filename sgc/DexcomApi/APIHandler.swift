//
//  Provider.swift
//  sgc
//
//  Created by roey ben arieh on 01/09/2022.
//

import Foundation
import UIKit

/// Global Dexcom handler, don't forget to initialize it with init()
var dexcom: Dexcom!

///class for parcing glucose reading from Dexcom Share API.
class glucoseReading{
    let value: Int
    let trendNum: Int
    let trendArrow: String
    let time: Date
    ///initialize glucose obj from json glucose reading from Dexcom Share API.
    init(jsonGlucoseReading:  [String:Any]){
        value = jsonGlucoseReading["Value"] as! Int
        
        if let trend = jsonGlucoseReading["Trend"] as? String {
            trendNum = DEXCOM_TREND_DIRECTIONS[trend]!
        }
        else if let trend = jsonGlucoseReading["Trend"] as? Int {
            trendNum = trend
        }
        else{
            trendNum = DEXCOM_TREND_DIRECTIONS["None"]!
        }
        
        trendArrow = DEXCOM_TREND_ARROWS[trendNum]
        var strTime = jsonGlucoseReading["WT"] as! String
        strTime.removeLast()
        strTime = String(strTime.dropFirst(5))
        time = Date(timeIntervalSince1970: TimeInterval((Float)(Float(strTime)!/1000.0)))
        //doesnt show accurate time - has about two hours error
    }
}

class Dexcom{
    //dexcom clarity account information
    var username = ""
    var password = ""
    var base_url = ""
    var session_id: String!
    var account_id: String!
    
    
    init(username: String, password: String, outsideUSA: Bool){
        self.password = password
        self.username = username
        self.base_url = outsideUSA ? DEXCOM_BASE_URL_OUS : DEXCOM_BASE_URL
        session_id = nil
        account_id = nil
        create_session()
    }
    
    /// easy to use formating of Dexcom api requests
    func request(method: String, endpoint: String, headers: [String:String]! = [:], jsonBody: [String:Any] = [:]) -> String!{
        //URL
        let url = URL(string: "\(base_url)/\(endpoint)")
        guard url != nil else {
            print("Error creating url object")
            return nil
        }
        
        // URL Request
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        
        //specify the formating of the request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //how we are incoding the body of the api request
        request.setValue("application/json", forHTTPHeaderField: "Accept") //what type incoding we want the response to contain
        
        //Specify the header
        //it is the fuction parameter 'headers'
        request.allHTTPHeaderFields = headers
        
        //Specify the body (the data that is passed to dexcom api)
        //it is the function parameter 'body'
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonBody, options: .fragmentsAllowed)
            request.httpBody = requestBody
        }
        catch{
            print("error creating the data object from json")
            return nil
        }

        //Set the request type
        request.httpMethod = method
        
        //Get the URLSession
        let session = URLSession.shared
        
        var result: String! = nil
        //Create a data task
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            }
            else if !data!.isEmpty{ //Got a response from the api
                //Parse the data
                do{
                    result = String(bytes: data!, encoding: .utf8)!
                }
                if result == nil{
                    print("Error when creating string from the api response")
                }
            }
        })
        //Fire off the data task
        dataTask.resume()
        var count = 0
        while(result == nil){
            Thread.sleep(forTimeInterval: 1)
            count += 1
            if(count >= 20){
                dataTask.cancel()
                print("Error: couldnt get glucose values")
                break //the functin will return nill at the end
            }
        }
        return result
    }
    
    // MARK: Validations
    ///making sure username and password exist
    func validateAccount(){
        if username == "" {
            print(ACCOUNT_ERROR_USERNAME_NULL_EMPTY)
        }
        else if password == ""{
            print(ACCOUNT_ERROR_PASSWORD_NULL_EMPTY)
        }
    }
    
    func validateAccountID(){
        if account_id == nil{
            print(SESSION_ERROR_ACCOUNT_ID_NULL_EMPTY)
            create_session()
        }
        if account_id == DEFAULT_SESSION_ID{
            print(SESSION_ERROR_ACCOUNT_ID_DEFAULT)
            create_session()
        }
    }
    
    func validateSessionID(){
        if session_id == nil{
            print(SESSION_ERROR_SESSION_ID_NULL)
            create_session()
        }
        if session_id == DEFAULT_SESSION_ID{
            print(SESSION_ERROR_SESSION_ID_DEFAULT)
            create_session()
        }
    }
    
    // MARK: Authentication
    func create_session(){
        validateAccount()
        var jsonBody: [String:String] = [
          "accountName": username,
          "password": password,
          "applicationId": DEXCOM_APPLICATION_ID,
        ]
        /*
        The Dexcom Share API at DEXCOM_AUTHENTICATE_ENDPOINT
        returns the account ID if credentials are valid -- whether
        the username is a classic username or email. Using the
        account ID the DEXCOM_LOGIN_ID_ENDPOINT is used to fetch
        a session ID.
        */
        let endpoint1 = DEXCOM_AUTHENTICATE_ENDPOINT
        let endpoint2 = DEXCOM_LOGIN_ID_ENDPOINT
        
        account_id = request(method: "POST", endpoint: endpoint1, jsonBody: jsonBody)
        account_id.removeLast()
        account_id.removeFirst()
        validateAccountID()
        do {
            jsonBody = [
                "accountId": account_id!,
                "password": password,
                "applicationId": DEXCOM_APPLICATION_ID
            ]
            
            session_id = request(method: "POST", endpoint: endpoint2,jsonBody: jsonBody)
            session_id.removeLast()
            session_id.removeFirst()
            validateSessionID()
        }
    }
    
    ///get max_count glucsose readings within specified minutes.
    func getGlucoseReadings(minutes: Int = 1440, maxCount: Int = 288) ->[glucoseReading]!{
        validateSessionID()
        if (minutes < 1 || minutes > 1440) || (maxCount < 1 || maxCount > 1440){
            return []
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //specifing the query items
        var components = URLComponents(string: "\(base_url)/\(DEXCOM_GLUCOSE_READINGS_ENDPOINT)")!

        components.queryItems = [
            URLQueryItem(name: "sessionId", value: session_id!),
            URLQueryItem(name: "minutes", value: String(minutes)),
            URLQueryItem(name: "maxCount", value: String(maxCount))
        ]
        
        // URL Request
        let request = NSMutableURLRequest(url: components.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        
        //specify the formating of the request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //how we are incoding the body of the api request
        request.setValue("application/json", forHTTPHeaderField: "Accept") //what type incoding we want the response to contain
        
        //Specify the body (the data that is passed to dexcom api)
        //it is the function parameter 'body'
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: [:], options: .fragmentsAllowed)
            request.httpBody = requestBody
        }
        catch{
            print("error creating the data object from json")
            return nil
        }

        //Set the request type
        request.httpMethod = "POST"
        
        //Get the URLSession
        let session = URLSession.shared
        
        var jsonGlucoseReadings: [[String:Any]]! = nil
        //Create a data task
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            }
            else if !data!.isEmpty{ //Got a response from the api
                //Parse the data
                do{
                    jsonGlucoseReadings = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String:Any]]
                }
                catch{
                    print("Error when creating dictionary from the api response")
                }
            }
        })
        //Fire off the data task
        dataTask.resume()
        var count = 0
        while(jsonGlucoseReadings == nil){
            Thread.sleep(forTimeInterval: 1)
            count += 1
            if(count >= 20){
                dataTask.cancel()
                print("Error: couldnt get glucose values")
                return nil //the functin will return nill at the end
            }
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        var glucoseReadings: [glucoseReading] = []
        if jsonGlucoseReadings!.count == 0 {
            return nil
        }
        for reading in jsonGlucoseReadings!{
            glucoseReadings.append(glucoseReading(jsonGlucoseReading: reading))
        }
        if glucoseReadings.isEmpty{
            return nil
        }
        return glucoseReadings
    }
    func getLatestGlucoseReading() -> glucoseReading!{
        let glucoseReadings = getGlucoseReadings(maxCount: 1)
        if glucoseReadings == nil{
            return nil
        }
        return glucoseReadings![0]
    }
}
