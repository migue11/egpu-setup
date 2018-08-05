//
//  UserEGPUPreferenceCellView.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/3/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines a user application eGPU preference cell.
class UserEGPUPreferenceCellView: NSTableCellView {
    
    /// Reference to the could not set label.
    @IBOutlet weak var couldNotSetLabel: NSTextField!
    
    /// Stores eGPU preference value.
    @IBOutlet weak var preferEGPUCheckBox: NSButton!
    
    /// Reference to the eGPU preference setting mechanism progress.
    @IBOutlet weak var preferenceProgressIndicator: NSProgressIndicator!
    
    /// Reference to the application data.
    weak var application: UserApplication!
    
    override func viewWillDraw() {
        couldNotSetLabel.isHidden = true
    }
    
    /// Sets eGPU preference.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func setEGPUPreference(_ sender: NSButton) {
        preferenceProgressIndicator.startAnimation(nil)
        WindowManager.disableTermination()
        application.setEGPUPreference(preferEGPU: sender.state == .on) { preferenceSet in
            DispatchQueue.main.async {
                WindowManager.enableTermination()
                self.preferenceProgressIndicator.stopAnimation(nil)
                if !preferenceSet {
                    sender.state = sender.state == .on ? .off : .on
                }
                self.couldNotSetLabel.isHidden = preferenceSet
            }
        }
    }
}
