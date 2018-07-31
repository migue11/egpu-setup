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
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        requestAgreementToDisclaimer()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
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
        rootWindow().setIsVisible(false)
        if !AlertManager.showAlert(withMessage: "eGPU Setup Disclaimer & License", withInfo: shortLicense, withFirstButton: "Agree", withSecondButton: "Disagree") {
            quit()
        }
        else {
            rootWindow().setIsVisible(true)
        }
    }
    
}
