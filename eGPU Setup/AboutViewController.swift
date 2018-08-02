//
//  AboutViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/2/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the about view.
class AboutViewController: NSViewController {

    @IBOutlet weak var versionLabel: NSTextField!
    
    @IBOutlet weak var appNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let bundleDictionary = Bundle.main.infoDictionary else { return }
        versionLabel.stringValue = "v\(bundleDictionary["CFBundleShortVersionString"] as? String  ?? "v1.0.0")"
        appNameLabel.stringValue = bundleDictionary["CFBundleName"] as? String ?? "eGPU Setup"
    }
    
    @IBAction func openLinkTo(_ sender: NSButton) {
        switch sender.title {
        case "@mac_editor":
            NSWorkspace.shared.open(macEditorProfileURL)
            break
        case "@eightarmedpet":
            NSWorkspace.shared.open(eightArmedPetProfileURL)
            break
        case "@goalque":
            NSWorkspace.shared.open(goalqueProfileURL)
            break
        case "@egpu.io":
            NSWorkspace.shared.open(moreHelpURL)
            break
        default: NSWorkspace.shared.open(projectGithubURL)
        }
    }
    
    
    
    
}
