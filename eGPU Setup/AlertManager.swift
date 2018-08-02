//
//  AlertManager.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines convenience functions for alert management.
class AlertManager {
    
    /// Root application window.
    static var rootWindow = {
        return NSApplication.shared.windows[0]
    }
    
    /// Shows an alert on the currently displayed window.
    ///
    /// - Parameters:
    ///   - message: Alert message.
    ///   - info: Additional information about the message.
    ///   - firstButton: The primary button.
    ///   - secondButton: The alternate button.
    /// - Returns: Result of the alert
    static func generateAlert(withMessage message: String, withInfo info: String? = nil, withStyle style: NSAlert.Style? = nil, withFirstButton firstButton: String, withSecondButton secondButton: String? = nil) -> NSAlert {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = info ?? ""
        alert.alertStyle = style ?? .warning
        alert.addButton(withTitle: firstButton)
        if secondButton != nil {
            alert.addButton(withTitle: secondButton!)
        }
        return alert
    }
    
    /// Shows authentication issue alert.
    static func showAuthProblemAlert() {
        let alert = generateAlert(withMessage: "Authorization Required", withInfo: "Please enter your password when prompted. Superuser privileges are necessary for the application to perform its tasks.", withStyle: .critical, withFirstButton: "OK")
        alert.beginSheetModal(for: rootWindow(), completionHandler: nil)
    }
    
}
