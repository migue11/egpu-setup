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
    
    /// Reference to the main application window.
    private lazy var rootWindow = {
        return NSApplication.shared.windows[0]
    }
    
    /// Root page view controller.
    private lazy var setupPageController = {
        self.rootWindow().contentViewController as! SetupPageController
    }
    
    /// Reference to the generic help view.
    private let helpViewController = HelpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - User actions.
extension SetupUninstallViewController {
    
    func showAuthProblemAlert() {
        let alert = AlertManager.generateAlert(withMessage: "Authorization Required", withInfo: "Please enter your password when prompted. Superuser privileges are necessary for the application to perform its tasks.", withStyle: .critical, withFirstButton: "OK")
        alert.beginSheetModal(for: rootWindow(), completionHandler: nil)
    }
    
    /// Starts the uninstallation procedure.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func executeUninstall(_ sender: Any) {
        let status = Authorization.requestSuperUser()
        if status == 0 {
            setupPageController().transition(toPage: Page.uninstallProgress)
        }
        else {
            showAuthProblemAlert()
        }
    }
    
    /// Starts the complete uninstallation procedure.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func executeUninstallAll(_ sender: Any) {
        let alert = AlertManager.generateAlert(withMessage: "Uninstall All Components", withInfo: "Are you sure you want to uninstall all components? This action cannot be undone.", withStyle: .critical, withFirstButton: "Cancel", withSecondButton: "Proceed")
        alert.beginSheetModal(for: rootWindow()) { response in
            if response != .alertFirstButtonReturn {
                DispatchQueue.main.async {
                    let status = Authorization.requestSuperUser()
                    if status == 0 {
                        self.setupPageController().transition(toPage: Page.uninstallProgress)
                    }
                    else {
                        self.showAuthProblemAlert()
                    }
                }
            }
        }
    }
    
    /// Configures the help view.
    func configureHelpViewController() {
        helpViewController.helpTitleLabel.stringValue = "Uninstallation Tips"
        helpViewController.helpSubtitleLabel.stringValue = "Making The Right Choice"
        helpViewController.helpDescriptionLabel.stringValue = """
        It is recommended that you use the default "Uninstall" option, and not "Uninstall All...". The former option allows system recovery in case it was unable to reboot after installation.

        Use "Uninstall All..." at your own risk. It will remove every safeguard mechanism that was previously installed on the system. As such, having a time machine backup is essential.
        """
    }
    
    /// Shows help regarding uninstallation.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showHelp(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        PopoverManager.showPopover(withWidth: 300, withHeight: 320, withViewController: helpViewController, withTarget: button)
        configureHelpViewController()
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
