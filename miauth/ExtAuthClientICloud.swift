//
//  ExtAuthClientICloud.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import UIKit
import CloudKit

class ExtAuthClientICloud: ExtAuthClient {
    static let sharedInstance = ExtAuthClientICloud()
    var authName = "iCloud"
    var authUserID = ""
    var isAvailable = false
    var priority = 1 //If iCloud is available, let's use that for basis for any future authentications
    
    let cloudKitContainer : CKContainer = CKContainer.defaultContainer()
    let cloudKitPublicDB : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    let cloudKitPrivateDB : CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    
    init() {
        isAvailable = self.isICloudActive()
    }
    
    func autoConnect() {
        print("ExternalAuthenticationClient \(authName) autoconnecting")
        cloudKitContainer.fetchUserRecordIDWithCompletionHandler{
            (recordId: CKRecordID?, error: NSError?) in
            if error != nil{
                print("Could not receive  iCloud user ID. Error = \(error)")
            } else {
                self.authUserID = recordId!.recordName
                print("iCloud user ID. = \(self.authUserID)")
            }
        }
    }
    
    private func isICloudActive() -> Bool
    {
        if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
            return true
        } else {
            return false
        }
    }
}
