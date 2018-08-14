//
//  SetupEGPUPreferencesViewController.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/3/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Cocoa

/// Defines the eGPU Preferences view controller.
class SetupEGPUPreferencesViewController: NSViewController {
    
    /// Reference to the back button.
    @IBOutlet weak var backButton: NSButton!
    
    /// Reference to the overall progress indicator.
    @IBOutlet weak var overallProgressIndicator: NSProgressIndicator!
    
    /// Reference to the no results label.
    @IBOutlet weak var noResultsLabel: NSTextField!
    
    /// Reference to the search bar.
    @IBOutlet weak var searchBar: NSSearchField!
    
    /// Reference to the primary table view.
    @IBOutlet weak var applicationTableView: NSTableView!
    
    /// Reference to the unselect all button.
    @IBOutlet weak var unselectAllButton: NSButton!
    
    /// Reference to the select all button.
    @IBOutlet weak var selectAllButton: NSButton!
    
    /// Reference to the reset all button.
    @IBOutlet weak var rescanButton: NSButton!
    
    /// Reference to the deep scan button.
    @IBOutlet weak var deepScanButton: NSButton!
    
    /// Reference to the fetch progress status.
    @IBOutlet weak var fetchProgressLabel: NSTextField!
    
    /// Shows progress of application fetching.
    @IBOutlet weak var fetchProgressIndicator: NSProgressIndicator!
    
    /// Reference to the help button.
    @IBOutlet weak var helpButton: NSButton!
    
    /// Reference to the generic help view.
    private let helpViewController = HelpViewController()
    
    /// Reference to user applications.
    private let userApplications = UserApplications.instance()
    
    /// List of applications to display
    private var apps = [UserApplication]()
    
    /// Root page view controller.
    lazy var setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    /// Singleton instance of view controller.
    private static var setupEGPUPreferencesViewController: SetupEGPUPreferencesViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ProcessInfo.processInfo.operatingSystemVersion.minorVersion == 13 {
            helpButton.frame = helpButton.frame.offsetBy(dx: 0, dy: 2)
        }
        noResultsLabel.isHidden = true
        overallProgressIndicator.isHidden = true
        configureSearchDelegate()
        configureTableViewDelegate()
        prepareView()
        fetchApplications()
    }
    
    /// Prepares the view.
    ///
    /// - Parameter toggle: The toggle.
    private func prepareView(withToggle toggle: Bool = false) {
        applicationTableView.usesAlternatingRowBackgroundColors = toggle
        searchBar.isEnabled = toggle
        !toggle ? fetchProgressIndicator.startAnimation(nil) : fetchProgressIndicator.stopAnimation(nil)
        unselectAllButton.isEnabled = toggle
        selectAllButton.isEnabled = toggle
        rescanButton.isEnabled = toggle
        deepScanButton.isEnabled = toggle
        fetchProgressLabel.isHidden = toggle
    }
    
}

// MARK: - Search management
extension SetupEGPUPreferencesViewController: NSSearchFieldDelegate, NSTextFieldDelegate {
    
    /// Configures the table view data source & delegate.
    private func configureSearchDelegate() {
        searchBar.delegate = self
    }
    
    func controlTextDidChange(_ obj: Notification) {
        while searchBar.stringValue.hasPrefix(" ") {
            searchBar.stringValue = String(searchBar.stringValue.dropFirst())
        }
        if searchBar.stringValue.isEmpty {
            apps = userApplications.applications
        }
        else {
            var filteredApps = [UserApplication]()
            for app in userApplications.applications {
                if app.name.lowercased().contains(searchBar.stringValue.lowercased()) || app.plistName.lowercased().contains(searchBar.stringValue.lowercased()) {
                    filteredApps.append(app)
                }
            }
            apps = filteredApps
        }
        applicationTableView.usesAlternatingRowBackgroundColors = self.apps.count > 0
        noResultsLabel.isHidden = self.apps.count > 0
        unselectAllButton.isEnabled = self.apps.count != 0
        selectAllButton.isEnabled = self.apps.count != 0
        applicationTableView.reloadData()
    }

}

// MARK: - Table view management
extension SetupEGPUPreferencesViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    /// Fetches applications.
    private func fetchApplications(doDeepScan deepScan: Bool = false) {
        searchBar.stringValue = ""
        noResultsLabel.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.userApplications.fetch(deepScan: deepScan)
            DispatchQueue.main.async {
                self.apps = self.userApplications.applications
                self.prepareView(withToggle: true)
                self.unselectAllButton.isEnabled = self.apps.count != 0
                self.selectAllButton.isEnabled = self.apps.count != 0
                self.applicationTableView.reloadData()
            }
        }
    }
    
    /// Configures the table view data source & delegate.
    private func configureTableViewDelegate() {
        applicationTableView.dataSource = self
        applicationTableView.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return apps.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.title == "Application" {
            let appCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "appCell"), owner: nil) as? UserApplicationCellView
            appCell?.appIconView.image = apps[row].icon
            appCell?.appNameLabel.stringValue = apps[row].name
            appCell?.appPlistLabel.stringValue = apps[row].plistName
            return appCell
        }
        else {
            let preferenceCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "preferEGPU"), owner: nil) as? UserEGPUPreferenceCellView
            preferenceCell?.preferEGPUCheckBox.state = apps[row].prefersEGPU ? .on : .off
            preferenceCell?.preferEGPUCheckBox.isEnabled = tableView.isEnabled
            preferenceCell?.application = apps[row]
            return preferenceCell
        }
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
}

// MARK: - User interaction
extension SetupEGPUPreferencesViewController {
    
    /// Configures the help view.
    private func configureHelpViewController() {
        if helpViewController.didConfigure { return }
        helpViewController.helpTitle = "eGPU Preferences"
        helpViewController.helpSubtitle = "Potential Complications"
        helpViewController.helpDescription = """
        Preferring external GPUs may:
            - Cause applications to crash when launched without the eGPU.
            - Not necessarily use external GPUs, depending on the app.
        
        It also has some edge cases:
            - Some apps may require a headless display adapter connected to the eGPU for proper functionaility.
            - Performance across mac-connected external displays and eGPUs may be very poor.
        
        Some recommendations:
            - Only set preferences for eGPU for specific applications.
            - Test your specific application(s) with and without eGPU plugged in.
            - Apps must be restarted for preferences to take effect.
        """
        helpViewController.didConfigure = true
    }
    
    /// Shows help.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showHelp(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        configureHelpViewController()
        PopoverManager.showPopover(withWidth: 300, withHeight: 500, withViewController: helpViewController, withTarget: button)
    }
    
    /// Returns to the previous menu.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func backToMenu(_ sender: Any) {
        setupPageController().transition(toPage: Page.start)
    }
    
    /// Prepares for rescan.
    func prepareRescan() {
        userApplications.applications.removeAll()
        apps.removeAll()
        applicationTableView.reloadData()
        prepareView()
    }
    
    /// Rescans apps.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func rescanApps(_ sender: NSButton) {
        prepareRescan()
        fetchApplications(doDeepScan: sender.title == "Deep Scan")
    }
    
    /// Toggles all interactive components related to the table view.
    ///
    /// - Parameter toggle: The toggle.
    private func toggleTableViewInteractiveComponents(withToggle toggle: Bool = false) {
        selectAllButton.isEnabled = toggle
        unselectAllButton.isEnabled = toggle
        rescanButton.isEnabled = toggle
        deepScanButton.isEnabled = toggle
        searchBar.isEnabled = toggle
        applicationTableView.isEnabled = toggle
        applicationTableView.reloadData()
        overallProgressIndicator.isHidden = toggle
        backButton.isEnabled = toggle
    }
    
    /// Toggles application eGPU preferences.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func toggleAllPreferences(_ sender: NSButton) {
        if apps.count == 0 { return }
        WindowManager.disableTermination()
        toggleTableViewInteractiveComponents()
        let preference = sender.title == "Set All"
        overallProgressIndicator.doubleValue = 0.0
        let originalTitle = sender.title
        sender.title = preference ? "Setting..." : "Unsetting..."
        var setCount = 0
        for app in apps {
            app.setEGPUPreference(preferEGPU: preference) { _ in
                setCount += 1
                DispatchQueue.main.async {
                    self.overallProgressIndicator.increment(by: 100.0 / Double(self.apps.count))
                    if setCount == self.apps.count {
                        WindowManager.enableTermination()
                        sender.title = originalTitle
                        self.toggleTableViewInteractiveComponents(withToggle: true)
                    }
                }
            }
        }
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
