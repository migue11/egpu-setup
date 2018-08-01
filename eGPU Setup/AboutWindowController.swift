//
//  AboutWindowController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/2/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Override for about view controller.
class AboutWindowController: NSWindowController {

    let aboutView = AboutViewController()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        contentViewController = aboutView
    }

}
