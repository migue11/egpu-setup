//
//  HelpViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/1/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines a support view controller for help.
class HelpViewController: NSViewController {

    /// Stores state of configuration.
    var didConfigure = false
    
    /// Describes the potential problems/solutions contextually.
    @IBOutlet weak var helpDescriptionLabel: NSTextField!
    
    /// Short summary of help provided.
    @IBOutlet weak var helpSubtitleLabel: NSTextField!
    
    /// Help topic label.
    @IBOutlet weak var helpTitleLabel: NSTextField!
    
    /// Shows macOS troublehsooting guide in Safari.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showTroubleShootingGuide(_ sender: Any) {
        let url = URL(string: "https://egpu.io/forums/mac-setup/guide-troubleshooting-egpus-on-macos/")!
        NSWorkspace.shared.open(url)
    }
    
    /// Shows eGPU.io forum thread for reports.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showForum(_ sender: Any) {
        let url = URL(string: "https://egpu.io/forums/")!
        NSWorkspace.shared.open(url)
    }
}
