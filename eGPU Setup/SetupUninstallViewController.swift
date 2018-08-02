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

    /// Reference to the help button.
    @IBOutlet weak var helpButton: NSButton!
    
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
    
    /// Reference to progress view controller.
    private let progressViewController = SetupProgressViewController.instance()
    
    /// Reference to the generic help view.
    private let helpViewController = HelpViewController()
    
    /// Reference to the generic help view for progress view.
    let progressHelpViewController = HelpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ProcessInfo.processInfo.operatingSystemVersion.minorVersion == 13 {
            helpButton.frame = helpButton.frame.offsetBy(dx: 0, dy: 2)
        }
    }
    
}

// MARK: - User actions.
extension SetupUninstallViewController {
    
    /// Prepare uninstallation procedure.
    func prepareUninstall(allComponents doAll: Bool = false) {
        configureProgressHelpViewController()
        progressViewController.progressTaskInformationLabelValue = "Validating system..."
        progressViewController.progressTaskLabelValue = !doAll ? "Uninstalling" : "Uninstalling All Components"
        progressViewController.progressTaskImage = NSImage(named: "Uninstall")
    }
    
    /// Perform uninstall procedure.
    func performUninstall(allComponents doAll: Bool = false) {
        // Perform uninstallation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.progressViewController.progressTaskInformationLabelValue = "System clean. Restart now to apply changes."
            self.progressViewController.progressTaskLabelValue = "Uninstallation Complete"
            self.progressViewController.taskCompleteStatusImageView.image = NSImage(named: "Tick")
            self.progressViewController.endProgress()
        }
    }
    
    /// Configures the progress help view.
    func configureProgressHelpViewController() {
        if progressHelpViewController.didConfigure { return }
        progressHelpViewController.helpTitle = "Uninstallation"
        progressHelpViewController.helpSubtitle = "Under The Hood"
        progressHelpViewController.helpDescription = """
        With "Uninstall", eGPU Setup performs the following tasks:
        - Undo's any system patches.
        - Removes NVIDIA Web Drivers if present.
        - Repairs kernel extension permissions.
        - Rebuilds kernel cache.
        
        "Uninstall All..." also performs the above duties, plus:
        - Removes eGPU Setup Recovery Tool.
        - Removes any littered system file backups.
        """
        progressHelpViewController.didConfigure = true
        progressViewController.helpViewController = progressHelpViewController
        progressViewController.helpViewHeight = 340
    }
    
    /// Starts the uninstallation procedure.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func executeUninstall(_ sender: Any) {
        prepareUninstall()
        setupPageController().transition(toPage: Page.progress) {
            self.performUninstall()
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
                    self.prepareUninstall(allComponents: true)
                    self.setupPageController().transition(toPage: Page.progress) {
                        self.performUninstall(allComponents: true)
                    }
                }
            }
        }
    }
    
    /// Configures the help view.
    func configureHelpViewController() {
        helpViewController.helpTitle = "Uninstallation Tips"
        helpViewController.helpSubtitle = "Making The Right Choice"
        helpViewController.helpDescription = """
        It is recommended that you use the default "Uninstall" option, and not "Uninstall All...". The former option allows system recovery in case it was unable to reboot after installation.

        Use "Uninstall All..." at your own risk. It will remove every safeguard mechanism that was previously installed on the system. As such, having a time machine backup is essential.
        """
    }
    
    /// Shows help regarding uninstallation.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showHelp(_ sender: Any) {
        configureHelpViewController()
        guard let button = sender as? NSButton else { return }
        PopoverManager.showPopover(withWidth: 300, withHeight: 320, withViewController: helpViewController, withTarget: button)
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
