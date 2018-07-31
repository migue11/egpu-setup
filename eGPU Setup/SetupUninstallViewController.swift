//
//  SetupUninstallViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupUninstallViewController: NSViewController {

    private static var setupUninstallViewController: SetupUninstallViewController! = nil
    
    let setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instance() -> SetupUninstallViewController {
        guard let viewController = setupUninstallViewController else {
            setupUninstallViewController = SetupUninstallViewController()
            return setupUninstallViewController
        }
        return viewController
    }
    
    @IBAction func executeUninstall(_ sender: Any) {
        setupPageController().transition(toPage: Page.uninstallProgress)
    }
    
    @IBAction func returnToMenu(_ sender: Any) {
        setupPageController().transition(toPage: Page.start)
    }
}
