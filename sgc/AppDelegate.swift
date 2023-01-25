//
//  AppDelegate.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let appRefreshTaskId = "com.roeyswift.sgc.refreshdexcomapi"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: AppDelegate.appRefreshTaskId, using: nil) { task in
                self.handleAppRefresh(task: task as! BGAppRefreshTask)
            }
        }
        scheduleBackgroundTask()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    func handleAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new refresh task.
        scheduleBackgroundTask()
        
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
           return
        }
        
        /// if there is connection to a bluetooth module
        if serial.connectedPeripheral != nil{
            print("[BGTASK] Perform bg fetch at: \(Date())")
            injectionHandler.handlerInjection()
            task.setTaskCompleted(success: true)
        }
    }
}

@available(iOS 13.0, *)
func scheduleBackgroundTask() {
    let request = BGAppRefreshTaskRequest(identifier: AppDelegate.appRefreshTaskId)
    
    // Fetch no earlier than 5 minutes from now.
    request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 5)
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Could not schedule the processing task: (error)")
    }
}
