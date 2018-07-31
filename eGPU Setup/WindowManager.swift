//
//  WindowManager.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines convenience functions for window management during sensitive tasks.
class WindowManager {
    
    /// Computed reference to the main window.
    private static let rootWindow = {
        return NSApplication.shared.windows[0]
    }
    
    /// Reference to the application delegate.
    private static let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    /// Disable ability to quit or terminate the application.
    static func disableTermination() {
        rootWindow().standardWindowButton(.closeButton)?.isEnabled = false
        appDelegate.quitApp.action = nil
    }
    
    /// Reinstate ability to quit or terminate the application.
    static func enableTermination() {
        rootWindow().standardWindowButton(.closeButton)?.isEnabled = true
        appDelegate.quitApp.action = #selector(appDelegate.quit)
    }
    
}
