//
//  SetupUninstallViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the uninstallation page.
class SetupUninstallViewController: NSViewController {

    /// Singleton instance of view controller.
    private static var setupUninstallViewController: SetupUninstallViewController! = nil
    
    /// Root page view controller.
    lazy var setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - User actions.
extension SetupUninstallViewController {
    
    /// Starts the uninstallation procedure.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func executeUninstall(_ sender: Any) {
        setupPageController().transition(toPage: Page.uninstallProgress)
    }
    
    /// Returns to the previous menu.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func returnToMenu(_ sender: Any) {
        setupPageController().transition(toPage: Page.start)
    }
    
}

// MARK: - Instance generation
extension SetupUninstallViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupUninstallViewController {
        guard let viewController = setupUninstallViewController else {
            setupUninstallViewController = SetupUninstallViewController()
            return setupUninstallViewController
        }
        return viewController
    }
    
}
