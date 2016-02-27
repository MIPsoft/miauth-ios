//
//  ExtAuthClientGoogle.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import Google

class ExtAuthClientGoogle: ExtAuthClient,GIDSignInDelegate {
    var authName = "Google"
    var authUserID = ""
    
    init() {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func autoConnect() {
        print("ExternalAuthenticationClient \(authName) autoconnecting")
    }
    
    func isAvailable() -> Bool
    {
        return false
    }
}
