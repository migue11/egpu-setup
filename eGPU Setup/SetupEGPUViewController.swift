//
//  SetupEGPUViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupEGPUViewController: NSViewController {

    private static var setupEGPUViewController: SetupEGPUViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instance() -> SetupEGPUViewController {
        guard let viewController = setupEGPUViewController else {
            setupEGPUViewController = SetupEGPUViewController()
            return setupEGPUViewController
        }
        return viewController
    }
    
}
