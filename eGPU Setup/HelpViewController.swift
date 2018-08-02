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
    var helpDescription: String!
    
    /// Short summary of help provided.
    @IBOutlet weak var helpSubtitleLabel: NSTextField!
    var helpSubtitle: String!
    
    /// Help topic label.
    @IBOutlet weak var helpTitleLabel: NSTextField!
    var helpTitle: String!
    
    override func viewDidLoad() {
        helpDescriptionLabel.stringValue = helpDescription
        helpSubtitleLabel.stringValue = helpSubtitle
        helpTitleLabel.stringValue = helpTitle
    }
    
    /// Shows macOS troublehsooting guide in Safari.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showTroubleShootingGuide(_ sender: Any) {
        NSWorkspace.shared.open(troubleshootingURL)
    }
    
    /// Shows eGPU.io forum thread for reports.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showForum(_ sender: Any) {
        NSWorkspace.shared.open(moreHelpURL)
    }
}
