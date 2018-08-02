//
//  SetupEGPUPreferencesController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/3/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the eGPU Preferences view controller.
class SetupEGPUPreferencesViewController: NSViewController {

    /// Reference to the help button.
    @IBOutlet weak var helpButton: NSButton!
    
    /// Reference to the generic help view.
    private let helpViewController = HelpViewController()
    
    /// Root page view controller.
    lazy var setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    /// Singleton instance of view controller.
    private static var setupEGPUPreferencesViewController: SetupEGPUPreferencesViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ProcessInfo.processInfo.operatingSystemVersion.minorVersion == 13 {
            helpButton.frame = helpButton.frame.offsetBy(dx: 0, dy: 2)
        }
    }
    
}

// MARK: - Table view management
extension SetupEGPUPreferencesViewController: NSTableViewDelegate, NSTableViewDataSource {
}

// MARK: - User interaction
extension SetupEGPUPreferencesViewController {
    
    /// Configures the help view.
    func configureHelpViewController() {
        if helpViewController.didConfigure { return }
        helpViewController.helpTitle = "eGPU Preferences"
        helpViewController.helpSubtitle = "Potential Complications"
        helpViewController.helpDescription = """
        Preferring external GPUs may:
            - Cause applications to crash when launched without the eGPU.
            - Not necessarily use external GPUs, depending on the app.
        
        It also has some edge cases:
            - Some apps may require a headless display adapter connected to the eGPU for proper functionaility.
            - Performance across mac-connected external displays and eGPUs may be very poor.
        
        Some recommendations:
            - Only set preferences for eGPU for specific applications.
            - Test your specific application(s) with and without eGPU plugged in.
            - Apps must be restarted for preferences to take effect.
        """
        helpViewController.didConfigure = true
    }
    
    /// Shows help.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showHelp(_ sender: NSButton) {
        configureHelpViewController()
        PopoverManager.showPopover(withWidth: 300, withHeight: 500, withViewController: helpViewController, withTarget: sender)
    }
    
    /// Returns to the previous menu.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func backToMenu(_ sender: Any) {
        setupPageController().transition(toPage: Page.start)
    }
    
}

// MARK: - Instance generation
extension SetupEGPUPreferencesViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupEGPUPreferencesViewController {
        guard let viewController = setupEGPUPreferencesViewController else {
            setupEGPUPreferencesViewController = SetupEGPUPreferencesViewController()
            return setupEGPUPreferencesViewController
        }
        return viewController
    }
    
}
