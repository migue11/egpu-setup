//
//  PopoverManager.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/1/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Manages creation of popovers
class PopoverManager {
    
    /// Instance of `NSPopover` view.
    private static let popover = NSPopover()
    
    /// Shows a popover view.
    ///
    /// - Parameters:
    ///   - width: Width of the view.
    ///   - height: Height of the view.
    ///   - viewController: Content of the view.
    static func showPopover(withWidth width: Double, withHeight height: Double, withViewController viewController: NSViewController, withTarget target: NSView) {
        popover.contentSize = NSSize(width: width, height: height)
        popover.behavior = .transient
        popover.contentViewController = viewController
        let entry = target.convert(target.bounds, to: NSApp.mainWindow?.contentView)
        popover.show(relativeTo: entry, of: (NSApp.mainWindow?.contentView)!, preferredEdge: .minY)
    }
    
}
