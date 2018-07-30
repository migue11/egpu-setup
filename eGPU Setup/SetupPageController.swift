//
//  SetupPageController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

class SetupPageController: NSPageController, NSPageControllerDelegate {
    
    let setupStartViewController = SetupStartViewController()
    let setupUninstallViewController = SetupUninstallViewController()
    let setupEGPUViewController = SetupEGPUViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        animator().selectedIndex = 0
        arrangedObjects = ["page1", "uninstall", "page2"]
        transitionStyle = .horizontalStrip
    }
    
    override func scrollWheel(with event: NSEvent) {
        nextResponder?.scrollWheel(with: event)
    }
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        return NSPageController.ObjectIdentifier(rawValue: object as! String)
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        switch identifier.rawValue {
        case "page1": return setupStartViewController
        case "uninstall": return setupUninstallViewController
        case "page2": return setupEGPUViewController
        default: return NSViewController()
        }
    }
    
    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        self.completeTransition()
    }
    
    func changePage(page: Int) {
        NSAnimationContext.runAnimationGroup(
            { _ in self.animator().selectedIndex = page }, completionHandler:  { self.completeTransition() })
    }
    
}
