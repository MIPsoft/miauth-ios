//
//  ExtAuthClientICloud.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import UIKit
import CloudKit
import LocalAuthentication //Support for fingerprint reader

enum FingerPrintResponse {
    case VerifyOk
    case VerifyError
    case NoFingerPrintReader
    case Fallback
}

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
    
    func isTouchIdPresent() -> Bool
    {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) ;
    }
    
    func authenticateAndSavePinUsingTouchID(pin:String!) -> FingerPrintResponse {
        let context = LAContext()
        var error: NSError?
        var response:FingerPrintResponse = .VerifyError
        //TODO: Asynkroninen. Tarviteen closure, jolla palautetaan lopputulos
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            let data:NSData! = pin!.dataUsingEncoding(NSUTF8StringEncoding)
            print("evaluatedPolicyDomainState=\(context.evaluatedPolicyDomainState)")
            context.setCredential(data, type: .ApplicationPassword)
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                 (success: Bool, authenticationError: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        print("evaluatedPolicyDomainState=\(context.evaluatedPolicyDomainState)")
                        //<2de8a593 108fa6ca 275cbb6a 90cb1bb1 def1ab2c 2c4781d7 0407ca33 fb3bd6b8>
                        //<763196ca 5e37cc2e fb84dea2 0770b1a1 2384cd64 a57a1ce2 88d88d71 ee8367fc
                        response = .VerifyOk
                    } else {
                        if let error = authenticationError {
                            if error.code == LAError.UserFallback.rawValue {
                                response =  .Fallback
                            }
                        }
                       response =  .VerifyError
                    }
                }
            }
        } else {
            response =  .NoFingerPrintReader
        }
        return response
}
    
}
