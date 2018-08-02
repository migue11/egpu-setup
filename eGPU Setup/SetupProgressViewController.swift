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
    
    /// Help button.
    @IBOutlet weak var helpButton: NSButton!
    
    /// Help view controller.
    weak var helpViewController: HelpViewController!
    
    /// Back button.
    @IBOutlet weak var restartLaterButton: NSButton!
    
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
        if ProcessInfo.processInfo.operatingSystemVersion.minorVersion == 13 {
            helpButton.frame = helpButton.frame.offsetBy(dx: 0, dy: 2)
        }
        progressIndicator.usesThreadedAnimation = true
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        updateViews()
        beginProgress()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        prepareWindow()
    }
    
    /// Prepares the window for process.
    private func prepareWindow() {
        taskCompleteStatusImageView.isHidden = true
        WindowManager.disableTermination()
    }
    
    /// Begins progress as indeterminate by default.
    func beginProgress() {
        restartLaterButton.isHidden = true
        taskCompleteActionButton.isHidden = true
        progressIndicator.isIndeterminate = true
        progressIndicator.startAnimation(nil)
    }
    
    /// Restores default window configuration.
    private func restoreWindowConfiguration() {
        taskCompleteActionButton.isHidden = false
        progressIndicator.stopAnimation(nil)
        WindowManager.enableTermination()
    }
    
    /// Updates the progress bar state.
    func updateProgress(by byProgress: Double) {
        updateViews()
        progressIndicator.isIndeterminate = false
        self.progressIndicator.increment(by: byProgress)
    }
    
    /// Changes progress to indeterminate state.
    func progressIndeterminate() {
        updateViews()
        progressIndicator.isIndeterminate = true
        progressIndicator.startAnimation(nil)
    }
    
    /// End progress.
    func endProgress() {
        updateViews()
        restartLaterButton.isHidden = false
        taskCompleteStatusImageView.isHidden = false
        progressIndicator.stopAnimation(nil)
        taskCompleteActionButton.isEnabled = true
        restoreWindowConfiguration()
    }
    
    /// Updates the subview contents.
    func updateViews() {
        if let taskInfo = progressTaskInformationLabelValue {
            taskInformationLabel.stringValue = taskInfo
        }
        if let task = progressTaskLabelValue {
            progressTaskLabel.stringValue = task
        }
        if let taskImage = progressTaskImage {
            progressTaskImageView.image = taskImage
        }
    }
    
}

// MARK: - User Interaction
extension SetupProgressViewController {
    
    /// Shows help regarding uninstallation.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showHelp(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        PopoverManager.showPopover(withWidth: 300, withHeight: 320, withViewController: helpViewController, withTarget: button)
    }
    
    /// Action to take once progress is complete.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func completeProgress(_ sender: Any) {
        Swipt.instance().execute(appleScriptText: "tell application \"Finder\" to restart")
    }
    
    /// Return to menu.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func backToMenu(_ sender: Any) {
        let startPage = SetupStartViewController.instance()
        startPage.configUpdated = false
        setupPageController().transition(toPage: Page.start)
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
