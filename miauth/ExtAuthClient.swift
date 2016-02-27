//
//  ExternalAuthenticationClient.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

protocol ExtAuthClient {
    var authName: String { get set }
    var authUserID: String { get set }
    var isAvailable: Bool { get set }
    
    func autoConnect()
    /*
    func init(name:String)
    
    
    {
        authName = name
        print("ExternalAuthenticationClient init for \(authName)")
    }
    
    func autoConnect() {
        print("ExternalAuthenticationClient \(authName) autoconnecting")
    } */
}
