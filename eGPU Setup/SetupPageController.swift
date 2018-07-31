//
//  SetupPageController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Primary setup management interface.
class SetupPageController: NSPageController, NSPageControllerDelegate {
    
    /// List of pages.
    private let pages: [String] = [Page.start, Page.uninstall, Page.uninstallProgress, Page.eGPUConfig]
    
    /// Map of available pages.
    private let availablePages = [
        Page.start: SetupStartViewController.instance(),
        Page.uninstall: SetupUninstallViewController.instance(),
        Page.uninstallProgress: SetupUninstallActivateViewController.instance(),
        Page.eGPUConfig: SetupEGPUViewController.instance()
    ]
    
    private let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSetupStart()
    }
    
    override func scrollWheel(with event: NSEvent) {
        nextResponder?.scrollWheel(with: event)
    }
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        return NSPageController.ObjectIdentifier(rawValue: object as! String)
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        guard let page = availablePages[identifier.rawValue] else {
            return NSViewController()
        }
        return page
    }
    
    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        self.completeTransition()
    }
    
}


// MARK: - Define custom convenience functionality
extension SetupPageController {
    
    /// Prepare start & start gathering system configuration.
    func initializeSetupStart() {
        delegate = self
        animator().selectedIndex = 0
        arrangedObjects = pages
        transitionStyle = .horizontalStrip
    }
    
    /// Change page dynamically.
    ///
    /// - Parameter page: The page identifier to change to.
    func transition(toPage page: String) {
        NSAnimationContext.runAnimationGroup({ _ in
            guard let indexOfViewController = pages.index(of: page) else {
                return
            }
            self.animator().selectedIndex = indexOfViewController
        }, completionHandler: { self.completeTransition() })
    }
    
}
