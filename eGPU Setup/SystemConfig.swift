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
class SystemConfig {
    
    /// Mac model name.
    static var model = "-"
    
    /// Mac operating system version.
    static var osVersion = "-"
    
    /// Mac operating system build version.
    static var osBuild = "-"
    
    /// Mac GPU configuration.
    static var gpus = 0
    
    /// Flag for discrete NVIDIA GPU.
    static var hasNVIDIADiscreteChip = false
    
    /// Flag for integrated Intel GPU.
    static var hasIntelIntegratedChip = false
    
    /// Flag for system already patched with NVIDIA eGPU support.
    static var eGPUPatched = "None"
    
    /// Mac thunderbolt type.
    static var thunderboltType = "-"
    
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
            } else {
                gpus = 0
                break
            }
            if device.isLowPower {
                hasIntelIntegratedChip = true
            } else {
                hasNVIDIADiscreteChip = true
            }
        }
        guard var constantsScript = ShellScripts.constants else { return }
        constantsScript = constantsScript.replacingOccurrences(of: " ", with: "\\\\ ")
        guard let systemConfigScript = ShellScripts.systemConfig else { return }
        swiptManager.execute(unixScriptFile: systemConfigScript, withArgs: [constantsScript], withShellType: .bash) { error, output in
            if let error = error {
                print(error)
                return
            }
            guard let data = output?.split(separator: "\r") else { return }
            if data.count < 3 { return }
            currentSIP = String(data[0])
            model = String(data[1])
            thunderboltType = String(data[2])
            eGPUPatched = String(data.count > 3 ? data[3] : "None")
        }
    }
    
    /// Checks if system information retrieval was incomplete.
    ///
    /// - Returns: True if retrieval was incomplete.
    static func isIncomplete() -> Bool {
        return model == "-" || osVersion == "-" || osBuild == "-" || gpus == 0 || currentSIP == "-" || thunderboltType == "-"
    }
    
}
