//
//  RealmDB.swift
//  sgc
//
//  Created by roey ben arieh on 03/02/2023.
//

import Foundation
import RealmSwift

let realm = DBInit()
//let realm = try! Realm(fileURL: Bundle.main.url(forResource: "default", withExtension: ".realm")!)


func DBInit() -> Realm{
    // if first time initializing the DB, that use premade one 'default.realm' in 'DB' folder
    if !realmFileExist(){
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".realm")
    }
    return try! Realm()
}
func copyFilesFromBundleToDocumentsFolderWith(fileExtension: String) {
    if let resPath = Bundle.main.resourcePath {
        do {
            let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
            for fileName in filteredFiles {
                if let documentsURL = documentsURL {
                    let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                    let destURL = documentsURL.appendingPathComponent(fileName)
                    do {
                        try FileManager.default.copyItem(at: sourceURL, to: destURL)
                    } catch CocoaError.fileNoSuchFile {
                        print("name, No such file")
                    } catch let error {
                        // other errors
                        print("name: \(error.localizedDescription)")
                    }
                }
            }
        } catch { }
    }
}
func realmFileExist() -> Bool{
    let RealmFile = Realm.Configuration.defaultConfiguration.fileURL!.path
    return FileManager.default.fileExists(atPath: RealmFile)
}
