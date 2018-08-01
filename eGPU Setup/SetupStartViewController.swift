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
    
    /// Detection status text label.
    @IBOutlet weak var detectInfoLabel: NSTextField!
    
    /// Error image view.
    @IBOutlet weak var errorImage: NSImageView!
    
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
        nextButton.isEnabled = false
        detectInfoLabel.isHidden = false
        detectInfoLabel.stringValue = "Detecting current configuration..."
        systemDataView.isHidden = true
        errorImage.isHidden = true
        progressIndicator.startAnimation(nil)
        guard let bundleDictionary = Bundle.main.infoDictionary else { return }
        guard let version = bundleDictionary["CFBundleShortVersionString"] as? String else { return }
        versionLabel.stringValue = version
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            SystemConfig.retrieve()
            DispatchQueue.main.async {
                self.progressIndicator.stopAnimation(nil)
                if SystemConfig.isIncomplete() {
                    self.errorImage.isHidden = false
                    self.detectInfoLabel.stringValue = "Could not retrieve configuration.\nFor safety purposes, eGPU Setup will not proceed."
                    return
                }
                self.nextButton.isEnabled = true
                self.detectInfoLabel.isHidden = true
                self.macModelLabel.stringValue = SystemConfig.model
                self.macOSLabel.stringValue = "\(SystemConfig.osVersion) (\(SystemConfig.osBuild))"
                self.currentSIPLabel.stringValue = SystemConfig.currentSIP
                self.gpusLabel.stringValue = SystemConfig.gpus
                self.systemDataView.isHidden = false
            }
        }
    }
    
}


// MARK: - User actions
extension SetupStartViewController {
    
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
        setupPageController().transition(toPage: Page.eGPUConfig)
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
