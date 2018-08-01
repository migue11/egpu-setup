//
//  SystemConfig.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Metal
import Foundation

/// Stores mac system configuration data.
struct SystemConfig {
    
    static var model = "-"
    static var osVersion = "-"
    static var osBuild = "-"
    static var gpus = "-"
    static var currentSIP = "-"
    
    /// Retrieves system information.
    static func retrieve() {
        let processInfo = ProcessInfo.processInfo
        osVersion = "\(processInfo.operatingSystemVersion.majorVersion).\(processInfo.operatingSystemVersion.minorVersion).\(processInfo.operatingSystemVersion.patchVersion)"
        osBuild = String(String(String(processInfo.operatingSystemVersionString.split(separator: "(")[1]).split(separator: " ")[1]).dropLast())
        gpus = MTLCopyAllDevices().map { $0.name }.joined(separator: "\n")
    }
    
    static func isIncomplete() -> Bool {
        return model == "-" || osVersion == "-" || osBuild == "-" || gpus.count == 0 || currentSIP == "-"
    }
    
}
