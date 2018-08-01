//
//  SetupStartViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the initial setup page.
class SetupStartViewController: NSViewController {
    
    /// Creates a reference to the generic help view.
    private let helpViewController = HelpViewController()
    
    /// Shows application version.
    @IBOutlet weak var versionLabel: NSTextField!
    
    /// Singleton instance of view controller.
    private static var setupStartViewController: SetupStartViewController! = nil
    
    /// Root page view controller.
    lazy var setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    
    /// Shows current system configuration.
    @IBOutlet weak var systemDataView: NSView!
    
    /// GPU label.
    @IBOutlet weak var gpusLabel: NSTextField!
    
    /// Current SIP status label.
    @IBOutlet weak var currentSIPLabel: NSTextField!
    
    /// macOS version label.
    @IBOutlet weak var macOSLabel: NSTextField!
    
    /// Mac model label.
    @IBOutlet weak var macModelLabel: NSTextField!
    
    /// Provides additional information about system status.
    @IBOutlet weak var systemStatusInfoLabel: NSTextField!
    
    /// Detection status text label.
    @IBOutlet weak var detectInfoLabel: NSTextField!
    
    /// Error image view.
    @IBOutlet weak var errorImage: NSImageView!
    
    /// Image which indicates system compatibility.
    @IBOutlet weak var systemStatusIndicator: NSImageView!
    
    /// Proceed to the next step of the installation process.
    @IBOutlet weak var nextButton: NSButton!
    
    /// Indicates indeterminate progress of system configuration scan.
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    /// Prepare start view.
    func prepareView() {
        prepareConfigurationLoad()
    }
    
    /// Prepares the view for loading system configuration.
    func prepareConfigurationLoad() {
        systemStatusIndicator.image = NSImage(named: NSImage.Name("Tick"))
        currentSIPLabel.textColor = NSColor.labelColor
        systemStatusInfoLabel.stringValue = "System meets basic requirements."
        nextButton.title = "Next"
        nextButton.isEnabled = false
        detectInfoLabel.isHidden = false
        detectInfoLabel.stringValue = "Detecting current configuration..."
        systemDataView.isHidden = true
        errorImage.isHidden = true
        progressIndicator.startAnimation(nil)
        guard let bundleDictionary = Bundle.main.infoDictionary else { return }
        guard let version = bundleDictionary["CFBundleShortVersionString"] as? String else { return }
        versionLabel.stringValue = version
        DispatchQueue.global(qos: .background).async {
            SystemConfig.retrieve()
            DispatchQueue.main.async {
                self.progressIndicator.stopAnimation(nil)
                if SystemConfig.isIncomplete() {
                    self.errorImage.isHidden = false
                    self.nextButton.title = "Retry"
                    self.nextButton.isEnabled = true
                    self.detectInfoLabel.stringValue = "Could not retrieve configuration. Disconnect any eGPUs. For safety reasons, eGPU Setup will not proceed."
                    return
                }
                self.detectInfoLabel.isHidden = true
                self.macModelLabel.stringValue = SystemConfig.model
                self.macOSLabel.stringValue = "\(SystemConfig.osVersion) (\(SystemConfig.osBuild))"
                self.currentSIPLabel.stringValue = SystemConfig.currentSIP
                self.gpusLabel.stringValue = String(SystemConfig.gpus)
                self.systemDataView.isHidden = false
                if SystemConfig.currentSIP == "Enabled" {
                    self.systemStatusIndicator.image = NSImage(named: NSImage.Name("Error"))
                    self.nextButton.title = "Retry"
                    self.currentSIPLabel.textColor = NSColor.systemOrange
                    self.systemStatusInfoLabel.stringValue = "SIP must be disabled."
                }
                self.nextButton.isEnabled = true
            }
        }
    }
    
}


// MARK: - User actions
extension SetupStartViewController {
    
    /// Configures the help view.
    func configureHelpViewController() {
        if helpViewController.didConfigure { return }
        helpViewController.helpTitleLabel.stringValue = "System Configuration"
        helpViewController.helpSubtitleLabel.stringValue = "Potential Issues & Complications"
        helpViewController.helpImageView.image = NSImage(named: "Macs")
        helpViewController.helpDescriptionLabel.stringValue = """
        For optimal experience:
        
        • Disable System Integrity Protection:
            - Boot into recovery (⌘ + R).
            - Launch Utilities > Terminal.
            - Type "csrutil disable", then reboot.
        
        • Disconnect any eGPUs that you may have plugged in.
        
        Retry once you have ensured the above.
        """
        helpViewController.didConfigure = true
    }
    
    /// Shows context-aware help.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showHelp(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        PopoverManager.showPopover(withWidth: 300, withHeight: 260, withViewController: helpViewController, withTarget: button)
        configureHelpViewController()
    }
    
    /// Switches to the uninstallation page.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func uninstallEGPUSupport(_ sender: Any) {
        setupPageController().transition(toPage: Page.uninstall)
    }
    
    /// Proceeds to the eGPU Configuration process page.
    ///
    /// - Parameter sender: The element responsilbe for the action.
    @IBAction func proceedToEGPUConfiguration(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        if button.title == "Next" {
            setupPageController().transition(toPage: Page.eGPUConfig)
        }
        else {
            prepareConfigurationLoad()
        }
    }
    
}

// MARK: - Instance generation
extension SetupStartViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupStartViewController {
        guard let viewController = setupStartViewController else {
            setupStartViewController = SetupStartViewController()
            return setupStartViewController
        }
        return viewController
    }
    
}
