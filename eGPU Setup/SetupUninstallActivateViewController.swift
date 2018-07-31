//
//  SetupUninstallActivateViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the uninstallation progress page.
class SetupUninstallActivateViewController: NSViewController {

    /// Singleton instance of view controller.
    private static var setupUninstallActivateViewController: SetupUninstallActivateViewController! = nil
    
    /// Indeterminate progress indicator for the uninstallation process.
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        prepareUninstall()
    }
    
    /// Prepares the view for the uninstallation process.
    func prepareUninstall() {
        progressIndicator.startAnimation(nil)
        WindowManager.disableTermination()
    }
    
}

// MARK: - Instance generation
extension SetupUninstallActivateViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupUninstallActivateViewController {
        guard let viewController = setupUninstallActivateViewController else {
            setupUninstallActivateViewController = SetupUninstallActivateViewController()
            return setupUninstallActivateViewController
        }
        return viewController
    }
    
}
