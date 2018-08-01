//
//  PrimaryWindowController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/2/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Override for the primary window.
class PrimaryWindow: NSWindow {
    
    override func close() {
        super.close()
        NSApplication.shared.terminate(nil)
    }
    
}
