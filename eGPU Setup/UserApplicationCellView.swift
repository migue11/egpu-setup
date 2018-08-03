//
//  UserApplicationCellView.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/3/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines a user application cell.
class UserApplicationCellView: NSTableCellView {
    
    /// Application name label.
    @IBOutlet weak var appNameLabel: NSTextField!
    
    /// Application plist file name label.
    @IBOutlet weak var appPlistLabel: NSTextField!
    
    /// Application name label.
    @IBOutlet weak var appIconView: NSImageView!
    
    /// Reference to a user application.
    weak var userApplication: UserApplication?
    
}
