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
    
    /// Root application window.
    lazy var rootWindow = {
        return NSApplication.shared.windows[0]
    }
    
    /// Root page view controller.
    lazy var setupPageController = {
        self.rootWindow().contentViewController as! SetupPageController
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        prepareWindowForUninstall()
    }
    
    /// Prepares the window for the uninstallation process.
    func prepareWindowForUninstall() {
        progressIndicator.startAnimation(nil)
        WindowManager.disableTermination()
    }
    
    /// Restores default window configuration.
    func restoreWindowConfiguration() {
        progressIndicator.stopAnimation(nil)
        WindowManager.enableTermination()
    }

}

// MARK: - User Interaction
extension SetupUninstallActivateViewController {
    
    /// Action to take once uninstallation is complete.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func uninstallDone(_ sender: Any) {
        setupPageController().transition(toPage: Page.uninstall)
        restoreWindowConfiguration()
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
