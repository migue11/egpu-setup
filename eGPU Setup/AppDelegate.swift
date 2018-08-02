//
//  AppDelegate.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa
import Swipt

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// Instance of SwiptManager.
    let swiptManager = SwiptManager()
    
    /// Application quit menu item reference.
    @IBOutlet weak var quitApp: NSMenuItem!
    
    /// Computed root application window.
    private let rootWindow = {
        return NSApplication.shared.windows[0]
    }
    
    /// Reference to the about view.
    private let aboutView = AboutViewController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        requestAgreementToDisclaimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Authorization.dropSuperUser()
    }
    
    /// Proceeds to paypal donation.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func donate(_ sender: Any) {
        NSWorkspace.shared.open(donationURL)
    }
    
    /// Closes the current window.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func closeWindow(_ sender: Any) {
        NSApplication.shared.keyWindow?.close()
    }
    
    /// Action to quit application.
    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

}

// MARK: - Alerts and early preparation
extension AppDelegate {

    /// Request user agreement to eGPU Setup License and disclaimer.
    func requestAgreementToDisclaimer() {
        if UserPrefs.agreeLicense {
            return
        }
        let alert = AlertManager.generateAlert(withMessage: "eGPU Setup Disclaimer & License", withInfo: shortLicense, withStyle: .informational, withFirstButton: "Agree", withSecondButton: "Disagree")
        alert.beginSheetModal(for: rootWindow()) { response in
            if response == .alertFirstButtonReturn {
                UserDefaults.standard.set(true, forKey: Preference.agreeLicenseKey)
            }
            else {
                DispatchQueue.main.async {
                    self.quit()
                }
            }
        }
    }
    
}
