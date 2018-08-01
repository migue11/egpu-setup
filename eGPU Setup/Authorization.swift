//
//  Authorization.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Foundation

/// Request authorization privileges.
class Authorization {
    
    /// Authorization reference
    private static var authRef: AuthorizationRef?
    
    /// Request superuser privileges.
    ///
    /// - Returns: Error code of the request.
    static func requestSuperUser() -> OSStatus {
        var authItem = AuthorizationItem(name: "com.mayank.eGPU-Setup.superuser", valueLength: 0, value: nil, flags: 0)
        var rights = AuthorizationRights(count: 1, items: &authItem)
        let flags: AuthorizationFlags = [.interactionAllowed, .extendRights]
        let osStatus = AuthorizationCreate(&rights, nil, flags, &authRef)
        return osStatus
    }
    
    /// Drops superuser privileges.
    static func dropSuperUser() {
        guard let auth = authRef else { return }
        AuthorizationFree(auth, [.destroyRights])
    }
    
}
