//
//  SetupProgressViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the uninstallation progress page.
class SetupProgressViewController: NSViewController {

    /// Singleton instance of view controller.
    private static var setupProgressViewController: SetupProgressViewController! = nil
    
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
        prepareWindow()
    }
    
    /// Prepares the window for process.
    func prepareWindow() {
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
extension SetupProgressViewController {
    
    /// Action to take once uninstallation is complete.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func uninstallDone(_ sender: Any) {
        setupPageController().transition(toPage: Page.uninstall)
        restoreWindowConfiguration()
    }
    
}

// MARK: - Instance generation
extension SetupProgressViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupProgressViewController {
        guard let viewController = setupProgressViewController else {
            setupProgressViewController = SetupProgressViewController()
            return setupProgressViewController
        }
        return viewController
    }
    
}
