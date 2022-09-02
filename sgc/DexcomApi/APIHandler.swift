//
//  Provider.swift
//  sgc
//
//  Created by roey ben arieh on 01/09/2022.
//

import Foundation
import UIKit

//MARK: Authentication

//gets the code from a redirect url, than call the function that gets the token
func getCodeFromRedirect(redirectUrl: String){
    // YourRedirectURL?code=ACCESS_TOKEN&state=MYSENTSTATE
    let firstSplit = redirectUrl.split(separator: "?")
    let secondSplit  = firstSplit[1].split(separator: "&")
    let state = secondSplit[1].split(separator: "=")[1]
    if(state == mystate){
        let returnedvalues = secondSplit[0].split(separator: "=")
        if returnedvalues[0] != "code"{
            return // the user didnt authorized the access OR an error accured
        }
        else{
            let authorization_code = String(returnedvalues[1])
            print("authorization_code: \(authorization_code)")
            obtainAccessToken(code: authorization_code)
        }
    }
}

//apt sted four - sends to dexcom the received code and in return gets a access token
func obtainAccessToken(code: String){
    //URL
    let url = URL(string: "\(baseApiUrl)token")
    
    guard url != nil else {
        print("Error creating url object")
        return
    }
    
    // URL Request
    var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    
    //Specify the header
    let headers = [
      "content-type": "application/x-www-form-urlencoded",
      "cache-control": "no-cache"
    ]
    request.allHTTPHeaderFields = headers
    
    //Specify the body (the data that is passed to dexcom api)
    let postData = NSMutableData()
    func addDataToBody(data: String){
        postData.append(data.data(using: String.Encoding.utf8)!)
    }
    addDataToBody(data: "client_secret=\(clientSecret)")
    addDataToBody(data: "&client_id=\(clientId)")
    addDataToBody(data: "&code=\(code)")
    addDataToBody(data: "&grant_type=authorization_code")
    addDataToBody(data: "&redirect_uri=\(redirectUrl)")
    request.httpBody = postData as Data
    
    //Set the request type
    request.httpMethod = "POST"
    
    //Get the URLSession
    let session = URLSession.shared
    
    //Create a data task
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error!)
        }
        else { //Got a response from the api
            //Parse the data
            do{
                let resultdic = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                /*EXAMPLE RESPONSE WOULD LOOK LIKE:
                ["expires_in": 7200,
                "token_type": Bearer,
                "access_token":{my access token},
                "refresh_token": {my refresh token}]
                */
                token = resultdic!["access_token"] as? String
                refreshToken = resultdic!["refresh_token"] as? String
            }
            catch{
                print("Error when parsing the spi response")
            }
        }
    })
    //Fire off the data task
    dataTask.resume()
}

func refreshTokens(){
    
}

//MARK: Obtaining data


//MARK: Handle errors


//MARK: Constants

let redirectUrl = "https://www.google.com/"
let baseApiUrl =
"https://api.dexcom.com/v2/oauth2/" // the base url that is used in the dexcom api

let mystate =
String(Int.random(in: 0..<99999999999999999)) //rundom string for security reasons

private let clientId =
""
private let clientSecret =
"" //you are very welcome to try using this secret :-)

//MARK: Variables
private var token: String? = nil
private var refreshToken: String? = nil
