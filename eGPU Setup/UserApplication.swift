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
class UserApplication: Comparable {
    
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
    
    static func < (lhs: UserApplication, rhs: UserApplication) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
    
    static func == (lhs: UserApplication, rhs: UserApplication) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }
    
    /// Sets eGPU preference for specified application.
    ///
    /// - Parameter preference: Preference to set.
    func setEGPUPreference(preferEGPU preference: Bool, onCompletion completion: @escaping (Bool) -> Void) {
        if prefersEGPU == preference {
            completion(true)
            return
        }
        Swipt.instance().asyncExecute(unixScriptFile: ShellScripts.setEGPU!, withArgs: [plistName], withShellType: .bash) { error, output in
            if output == "Set." {
                completion(true)
                self.prefersEGPU = preference
                return
            }
            completion(false)
        }
    }
    
    /// Checks application's eGPU preference.
    func checkEGPUPreference() {
        Swipt.instance().execute(unixScriptFile: ShellScripts.setEGPU!, withArgs: [plistName, "true"], withShellType: .bash) { error, output in
            if output == "Preferred." {
                self.prefersEGPU = true
            }
        }
    }
    
}
