//
//  AppDelegate.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/30/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var quitApp: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        quitApp.action = #selector(AppDelegate.quit)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

}

