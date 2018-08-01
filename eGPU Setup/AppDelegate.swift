//
//  AppDelegate.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var quitApp: NSMenuItem!
    
    private let rootWindow = {
        return NSApplication.shared.windows[0]
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        requestAgreementToDisclaimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Authorization.dropSuperUser()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
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
