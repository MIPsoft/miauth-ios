//
//  ExtAuthClientGoogle.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

class ExtAuthClientGoogle: ExtAuthClient {
    static let sharedInstance = ExtAuthClientGoogle()
    var authName = "Google"
    var authUserID = ""
    var isAvailable = false
    
    init() {
        //This is initialized from AppDelegate, since we need to handle url scheme stuff from there
    }
    
    func autoConnect() {
        print("ExternalAuthenticationClient \(authName) autoconnecting")
    }
    
    func signInOk(userId:String,email:String,name:String)
    {
        isAvailable = true
        authUserID = userId
    }

}
