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
    var priority: Int { get set } //smallest priority is the best
    
    func autoConnect()
}
