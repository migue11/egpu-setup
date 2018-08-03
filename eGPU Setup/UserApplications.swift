//
//  UserApplications.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/3/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Foundation
import Cocoa

/// Defines capability to fetch applications.
class UserApplications {
    
    /// Singleton instance.
    static var userApplications: UserApplications?
    
    /// List of directories where applications can occur.
    let applicationsDirectories = FileManager.default.urls(for: .applicationDirectory, in: .allDomainsMask)
    
    /// List of potential directories where applications can occur.
    let potentialApplicationDirectories = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
    
    /// List of applications.
    var applications = [UserApplication]()
    
    /// List of exceptions to trim search.
    var exceptions = [String]()
    
}

// MARK: - Application fetching.
extension UserApplications {
    
    /// Fetches applications in the given `directory`.
    ///
    /// - Parameter directory: The directory to search.
    private func fetchApps(inDirectory directory: URL) {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants])
            for file in fileURLs {
                if file.pathExtension == "app" {
                    let userApplication = UserApplication()
                    userApplication.icon = NSWorkspace.shared.icon(forFile: file.path)
                    userApplication.name = String(file.lastPathComponent.dropLast(4))
                    Swipt.instance().execute(appleScriptText: "id of app \"\(String(describing: userApplication.name!))\"") { error, output in
                        if error != nil {
                            userApplication.plistName = "Unable to load."
                            return
                        }
                        userApplication.plistName = output
                    }
                    applications.append(userApplication)
                }
                else if FileManager.default.fileExists(atPath: file.path, isDirectory: nil) {
                    if exceptions.contains(file.lastPathComponent) { continue }
                    fetchApps(inDirectory: file)
                }
            }
        } catch {
            // do nothing
        }
            
    }
    
    /// Fetches all applications.
    func fetch(deepScan deep: Bool = false) {
        for directory in applicationsDirectories {
            fetchApps(inDirectory: directory)
        }
        if deep {
            for directory in potentialApplicationDirectories {
                fetchApps(inDirectory: directory)
            }
        }
        applications.sort()
    }
    
}

// MARK: - Instance generation
extension UserApplications {
    
    /// Defines an instance of the view controller, iff it has not be created already.
    ///
    /// - Returns: Shared instance of the view controller.
    static func instance() -> UserApplications {
        guard let viewController = userApplications else {
            userApplications = UserApplications()
            return userApplications!
        }
        return viewController
    }
    
}

