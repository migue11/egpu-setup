//
//  SetupProgressViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the uninstallation progress page.
class SetupProgressViewController: NSViewController {

    /// Singleton instance of view controller.
    private static var setupProgressViewController: SetupProgressViewController! = nil
    
    /// Image view for task completion status.
    @IBOutlet weak var taskCompleteStatusImageView: NSImageView!
    
    /// Shows additional information about the task.
    @IBOutlet weak var taskInformationLabel: NSTextField!
    var progressTaskInformationLabelValue: String!
    
    /// Progress task image view.
    @IBOutlet weak var progressTaskImageView: NSImageView!
    var progressTaskImage: NSImage!
    
    /// Progress task label.
    @IBOutlet weak var progressTaskLabel: NSTextField!
    var progressTaskLabelValue: String!
    
    /// Single action button for task.
    @IBOutlet weak var taskCompleteActionButton: NSButton!

    /// Indeterminate progress indicator for the uninstallation process.
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    /// Root application window.
    lazy var rootWindow = {
        return NSApplication.shared.windows[0]
    }
    
    /// Root page view controller.
    lazy var setupPageController = {
        self.rootWindow().contentViewController as! SetupPageController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressIndicator.usesThreadedAnimation = false
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let taskInfo = progressTaskInformationLabelValue {
            taskInformationLabel.stringValue = taskInfo
        }
        if let task = progressTaskLabelValue {
            progressTaskLabel.stringValue = task
        }
        if let taskImage = progressTaskImage {
            progressTaskImageView.image = taskImage
        }
        beginProgress()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        prepareWindow()
    }
    
    /// Prepares the window for process.
    func prepareWindow() {
        taskCompleteStatusImageView.isHidden = true
        taskCompleteActionButton.isHidden = true
        WindowManager.disableTermination()
    }
    
    /// Begins progress as indeterminate by default.
    func beginProgress() {
        progressIndicator.isIndeterminate = true
        progressIndicator.startAnimation(nil)
    }
    
    /// Restores default window configuration.
    func restoreWindowConfiguration() {
        taskCompleteActionButton.isHidden = false
        progressIndicator.stopAnimation(nil)
        WindowManager.enableTermination()
    }
    
    /// Updates the progress bar state.
    func updateProgress(by byProgress: Double) {
        progressIndicator.isIndeterminate = false
        self.progressIndicator.increment(by: byProgress)
    }
    
    /// Changes progress to indeterminate state.
    func progressIndeterminate() {
        progressIndicator.isIndeterminate = true
        progressIndicator.startAnimation(nil)
    }

}

// MARK: - User Interaction
extension SetupProgressViewController {
    
    /// Action to take once uninstallation is complete.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func uninstallDone(_ sender: Any) {
        setupPageController().transition(toPage: Page.uninstall)
        restoreWindowConfiguration()
    }
    
}

// MARK: - Instance generation
extension SetupProgressViewController {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> SetupProgressViewController {
        guard let viewController = setupProgressViewController else {
            setupProgressViewController = SetupProgressViewController()
            return setupProgressViewController
        }
        return viewController
    }
    
}
