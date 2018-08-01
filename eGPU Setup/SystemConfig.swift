//
//  SystemConfig.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Metal
import Foundation
import Swipt

/// Stores mac system configuration data.
struct SystemConfig {
    
    /// Mac model name.
    static var model = "-"
    
    /// Mac operating system version.
    static var osVersion = "-"
    
    /// Mac operating system build version.
    static var osBuild = "-"
    
    /// Mac GPU configuration.
    static var gpus = 0
    
    static var hasNVIDIADiscreteChip = false
    
    /// Mac system integrity protection status.
    static var currentSIP = "-"
    
    /// Reference to the singleton SwiptManager instance.
    static let swiptManager = Swipt.instance()
    
    /// Retrieves system information.
    static func retrieve() {
        let processInfo = ProcessInfo.processInfo
        osVersion = "\(processInfo.operatingSystemVersion.majorVersion).\(processInfo.operatingSystemVersion.minorVersion).\(processInfo.operatingSystemVersion.patchVersion)"
        osBuild = String(String(String(processInfo.operatingSystemVersionString.split(separator: "(")[1]).split(separator: " ")[1]).dropLast())
        let devices = MTLCopyAllDevices()
        for device in devices {
            if !device.isRemovable {
                gpus += 1
            }
            else {
                gpus = 0
                break
            }
            if device.name.lowercased().contains("nvidia") {
                hasNVIDIADiscreteChip = true
            }
        }
        guard let systemConfigScript = Bundle.main.path(forResource: "system_config", ofType: "sh") else { return }
        swiptManager.execute(unixScriptFile: systemConfigScript) { error, output in
            guard let data = output?.split(separator: "\r") else { return }
            currentSIP = String(data[0])
            model = String(data[1])
        }
    }
    
    /// Checks if system information retrieval was incomplete.
    ///
    /// - Returns: True if retrieval was incomplete.
    static func isIncomplete() -> Bool {
        return model == "-" || osVersion == "-" || osBuild == "-" || gpus == 0 || currentSIP == "-"
    }
    
}
