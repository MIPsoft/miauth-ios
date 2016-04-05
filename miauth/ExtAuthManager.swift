//
//  ExtAuthManager.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import LocalAuthentication //Support for fingerprint reader
import UIKit

enum PinCodeQueryType {
    case SetNew
    case Validate
}

class ExtAuthManager {
    static let sharedInstance = ExtAuthManager()
    var authenticators:Array<ExtAuthClient> = []
    var attributes = [String: String]()
    var pinCodeQueryType:PinCodeQueryType = .Validate
    var pinCodeLength:Int = 4
    var callingAppCallback:String = ""
    var callingAppName:String = ""
    
    init()
    {
        print("** CREATE ExtAuthManager")
        authenticators.append(ExtAuthClientGoogle.sharedInstance)
        authenticators.append(ExtAuthClientICloud.sharedInstance)
        doAutoConnect()
    }
    
    func isMiAuthURL(url:String) -> Bool {
        callingAppCallback = ""
        callingAppName = ""
        //url = miauth://authenticate?callbackurl=com.mipsoft.miauth-ios-sampleApp&app=miAuth+esimerkkiohjelma
        let urlComponents = NSURLComponents(string: url)
        if let scheme = urlComponents?.scheme {
            if scheme == "miauth" {
                let queryItems = urlComponents?.queryItems
                if let callbackurl = queryItems?.filter({$0.name == "callbackurl"}).first {
                    callingAppCallback = callbackurl.value!
                    if let app = queryItems?.filter({$0.name == "app"}).first {
                        callingAppName = app.value!
                        print("callbackurl=\(callingAppCallback) app=\(callingAppName)")
                        return true
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func doAutoConnect()
    {
        for ac in authenticators {
            if  ac.isAvailable {
                ac.autoConnect()
            }
        }
    }
    
    func setAttribute(attr:String,key:String) {
        attributes[key] = attr
    }
    
    
    func fingerprintReaderIsAvailable() -> Bool {
        var error: NSError?
        let context = LAContext()
        return context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func fingerprintReaderReadNow(ok:()->(), fallback:()->(), notok:()->())  {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success: Bool, authenticationError: NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        ok()
                    } else {
                        if let error = authenticationError {
                            if error.code == LAError.UserFallback.rawValue {
                                fallback()
                                return
                            }
                        }
                        notok()
                    }
                }
            }
        } else {
            notok()
        }
    }
    
    /*
    func myOk()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("returnToCallingAppEvent", object: nil)
    }
*/
 
    func returnToCallingApp(authenticated:Bool) -> Bool {
        let url:String = "\(callingAppCallback)://authentication?status=\(authenticated)"
        if let miauthCallbackURL:NSURL = NSURL(string:url) {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(miauthCallbackURL)) {
                application.openURL(miauthCallbackURL);
                return true
            }
            return false
        }
        return false
    }

}
