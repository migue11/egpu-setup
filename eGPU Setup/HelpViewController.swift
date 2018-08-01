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
    
    /// Help accessory image view for context.
    @IBOutlet weak var helpImageView: NSImageView!
    
}
