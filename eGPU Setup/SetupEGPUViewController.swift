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
    
    /// eGPU selection image view.
    @IBOutlet weak var eGPUSelectionImageView: NSImageView!
    
    /// eGPU detection progress label.
    @IBOutlet weak var eGPUProgressLabel: NSTextField!
    
    /// eGPU detection progress indicator.
    @IBOutlet weak var eGPUProgressIndicator: NSProgressIndicator!
    
    /// Help button.
    @IBOutlet weak var helpButton: NSButton!
    
    /// Install button.
    @IBOutlet weak var installButton: NSButton!
    
    /// Reference to the generic help view.
    private let helpViewController = HelpViewController()
    
    /// Root page view controller.
    lazy var setupPageController = {
        NSApplication.shared.windows[0].contentViewController as! SetupPageController
    }
    
    /// A background queue.
    let queue = DispatchQueue.global(qos: .background)
    
    /// Decides if view needs update.
    var purgeUpdate = false
    
    /// Singleton instance of view controller.
    private static var setupEGPUViewController: SetupEGPUViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ProcessInfo.processInfo.operatingSystemVersion.minorVersion == 13 {
            helpButton.frame = helpButton.frame.offsetBy(dx: 0, dy: 2)
        }
        prepareView()
        requestEGPUInformation()
    }
    
    /// Prepares the view.
    private func prepareView(withToggle toggle: Bool = false) {
        eGPUSelectionImageView.isHidden = !toggle
        installButton.isEnabled = toggle
        !toggle ? eGPUProgressIndicator.startAnimation(nil) : eGPUProgressIndicator.stopAnimation(nil)
    }
    
    /// Computes required system patches.
    ///
    /// - Returns: Description of patches required.
    private func computeRequestedPatches() -> String {
        let patchString = ""
        return patchString
    }
    
    /// Requests external GPU information, if connected.
    ///
    /// - Parameter completionHandler: Retrieves any found data, or returns `nil`.
    private func requestEGPUInformation() {
        queue.async {
            Swipt.instance().execute(unixScriptFile: ShellScripts.detectEGPU!, withShellType: .bash) { error, output in
                if error != nil {
                    return
                }
                if output == nil || output!.isEmpty {
                    sleep(2)
                    self.requestEGPUInformation()
                    return
                }
                guard let data = output?.split(separator: "\r") else {
                    return
                }
                if data.count != 2 {
                    return
                }
                else {
                    DispatchQueue.main.async {
                        if self.purgeUpdate {
                            return
                        }
                        self.installButton.title = "Install"
                        self.eGPUSelectionImageView.image = data[1] == "NVIDIA" ? NSImage(named: "NVIDIA") : NSImage(named: "AMD")
                        self.eGPUProgressLabel.stringValue = String(data[0])
                        self.prepareView(withToggle: true)
                    }
                }
            }
        }
    }
    
}

// MARK: - User interaction
extension SetupEGPUViewController {
    
    /// Configures help view.
    func configureHelpViewController() {
        if helpViewController.didConfigure { return }
        helpViewController.helpTitle = "eGPU Recommendations"
        helpViewController.helpSubtitle = "Involved Complications"
        helpViewController.helpDescription = """
        AMD eGPUs have native support in macOS, meaning that non-thunderbolt 3 macs are only deprived of support because of their thunderbolt specification. This makes the patch simpler:
            - Overwrite Thunderbolt 3 requirements in the system.
            - Rebuild kernel cache.
        
        The only known complication with AMD eGPUs are with macs having discrete NVIDIA GPUs. Problems include:
            - Display connected to AMD eGPU may not power up.
            - If a display is connected to the AMD eGPU, it may cause substantial interface lag.
        
        eGPU Setup incorporates a bypass for the above exception, but that bypass has the following limitations:
            - Loss of internal display brightness control.
            - Potential increase in overall system operation temperature.
            - Loss of use of discrete GPU as long as bypass is in place.
            - May not apply to, or work with macs without integrated GPUs, such as iMacs.
        
        NVIDIA eGPUs have the following complications:
            - No hot-unplug support.
            - Hot-plugging may not guarantee functionality.
            - Potential problems with eGPU recognition.
            - Conflicts with macs with discrete AMD GPUs.
        
        Exception cases again include macs with discrete NVIDIA GPUs that may prevent NVIDIA eGPUs from using OpenCL. A bypass is included, with the same limitations as previously mentioned.
        """
        helpViewController.didConfigure = true
    }
    
    /// Shows the help view.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func showHelp(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        configureHelpViewController()
        PopoverManager.showPopover(withWidth: 450, withHeight: 640, withViewController: helpViewController, withTarget: button)
    }
    
    /// Returns to the previous page.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func backToMenu(_ sender: Any) {
        setupPageController().transition(toPage: Page.start)
    }
    
    /// Chooses appropriate eGPU setup option.
    ///
    /// - Parameter sender: The element responsible for the action.
    @IBAction func chooseEGPUSetupOption(_ sender: NSButton) {
        switch sender.title {
        case "Automatic":
            purgeUpdate = false
            queue.suspend()
            prepareView()
            installButton.title = "Install"
            eGPUProgressLabel.stringValue = "Waiting for eGPU..."
            requestEGPUInformation()
            break
        case "AMD":
            purgeUpdate = true
            queue.suspend()
            prepareView(withToggle: true)
            eGPUSelectionImageView.image = NSImage(named: "AMD")
            eGPUProgressLabel.stringValue = "AMD Generic Device"
            installButton.title = "Next"
            break
        default:
            purgeUpdate = true
            queue.suspend()
            prepareView(withToggle: true)
            eGPUSelectionImageView.image = NSImage(named: "NVIDIA")
            eGPUProgressLabel.stringValue = "NVIDIA Generic Device"
            installButton.title = "Next"
        }
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
