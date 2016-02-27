//
//  ExtAuthManager.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

class ExtAuthManager {
    static let sharedInstance = ExtAuthManager()
    var authenticators:Array<ExtAuthClient> = []
    var attributes = [String: String]()
    
    init()
    {
        authenticators.append(ExtAuthClientGoogle.init())
        authenticators.append(ExtAuthClientICloud.init())
        doAutoConnect()
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

}
