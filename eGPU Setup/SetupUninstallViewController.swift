//
//  SetupUninstallViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupUninstallViewController: NSViewController {

    let setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func returnToMenu(_ sender: Any) {
        setupPageController().changePage(page: 0)
    }
}
