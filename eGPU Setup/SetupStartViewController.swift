//
//  SetupStartViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupStartViewController: NSViewController {
    
    lazy var setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        progressIndicator.startAnimation(nil)
    }
    
    @IBAction func uninstallEGPUSupport(_ sender: Any) {
        setupPageController().changePage(page: 1)
    }
    
    @IBAction func proceedToEGPUSpecs(_ sender: Any) {
        setupPageController().changePage(page: 2)
    }
    
}
