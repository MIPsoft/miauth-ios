//
//  ExtAuthClientGoogle.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//
class ExtAuthClientGoogle: ExtAuthClient {
    var authName = "Google"
    var authUserID = ""
    
    init() {
    }
    
    func autoConnect() {
        print("ExternalAuthenticationClient \(authName) autoconnecting")
    }
    
    func isAvailable() -> Bool
    {
        return false
    }
}
