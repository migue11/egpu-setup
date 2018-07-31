//
//  SetupStartViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupStartViewController: NSViewController {
    
    private static var setupStartViewController: SetupStartViewController! = nil
    
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
        setupPageController().transition(toPage: Page.uninstall)
    }
    
    @IBAction func proceedToEGPUConfiguration(_ sender: Any) {
        setupPageController().transition(toPage: Page.eGPUConfig)
    }
    
    static func instance() -> SetupStartViewController {
        guard let viewController = setupStartViewController else {
            setupStartViewController = SetupStartViewController()
            return setupStartViewController
        }
        return viewController
    }
    
}
