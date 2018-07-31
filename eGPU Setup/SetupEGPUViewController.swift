//
//  SetupEGPUViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the eGPU configuration process page.
class SetupEGPUViewController: NSViewController {

    /// Singleton instance of view controller.
    private static var setupEGPUViewController: SetupEGPUViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Instance generation
extension SetupEGPUViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupEGPUViewController {
        guard let viewController = setupEGPUViewController else {
            setupEGPUViewController = SetupEGPUViewController()
            return setupEGPUViewController
        }
        return viewController
    }
    
}
