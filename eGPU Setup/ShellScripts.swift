//
//  ShellScripts.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/1/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Foundation

/// Abstracts access to shell scripts.
class ShellScripts {
    
    /// system_config.sh
    static var systemConfig: String? {
        return Bundle.main.path(forResource: "system-config", ofType: "sh")
    }
    
    /// constants.sh
    static var constants: String? {
        return Bundle.main.path(forResource: "constants", ofType: "sh")
    }
    
    /// set-eGPU.sh
    static var setEGPU: String? {
        return ProcessInfo.processInfo.operatingSystemVersion.minorVersion == 13 ?  Bundle.main.path(forResource: "set-eGPU-HS", ofType: "sh") : Bundle.main.path(forResource: "set-eGPU-M", ofType: "sh")
    }
    
    /// detect-eGPU.sh
    static var detectEGPU: String? {
        return Bundle.main.path(forResource: "detect-eGPU", ofType: "sh")
    }
    
}
