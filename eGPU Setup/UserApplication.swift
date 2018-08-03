//
//  UserApplication.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/3/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa
import Foundation

/// Abstracts a user application.
class UserApplication {
    
    /// Application name.
    var name: String!
    
    /// Application .plist name.
    var plistName: String!
    
    /// Application .plist file.
    var plistFile: String!
    
    /// Application eGPU preference state.
    var prefersEGPU = false
    
    /// Application icon.
    var icon: NSImage!
    
    
}
