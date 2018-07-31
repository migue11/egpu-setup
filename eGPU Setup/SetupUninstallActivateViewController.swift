//
//  SetupUninstallActivateViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupUninstallActivateViewController: NSViewController {

    private static var setupUninstallActivateViewController: SetupUninstallActivateViewController! = nil
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSApplication.shared.windows[0].standardWindowButton(.closeButton)?.isEnabled = false
        let delegate = NSApplication.shared.delegate as! AppDelegate
        delegate.quitApp.action = nil
        print("loaded uninstallActivate")
        progressIndicator.startAnimation(nil)
    }
    
    static func instance() -> SetupUninstallActivateViewController {
        guard let viewController = setupUninstallActivateViewController else {
            setupUninstallActivateViewController = SetupUninstallActivateViewController()
            return setupUninstallActivateViewController
        }
        return viewController
    }
    
}
