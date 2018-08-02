//
//  SetupEGPUPreferencesController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/3/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupEGPUPreferencesViewController: NSViewController {

    /// Singleton instance of view controller.
    private static var setupEGPUPreferencesViewController: SetupEGPUPreferencesViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

// MARK: - Instance generation
extension SetupEGPUPreferencesViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupEGPUPreferencesViewController {
        guard let viewController = setupEGPUPreferencesViewController else {
            setupEGPUPreferencesViewController = SetupEGPUPreferencesViewController()
            return setupEGPUPreferencesViewController
        }
        return viewController
    }
    
}
