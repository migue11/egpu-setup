//
//  UserPrefs.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 7/31/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Foundation

/// Defines available preferences to set.
class Preference {
    
    /// Key for state of license agreement.
    static let agreeLicenseKey = "agreeLicense"
    
}

/// Defines user preferences.
class UserPrefs {
    
    /// User license agreement status.
    static var agreeLicense = UserDefaults.standard.bool(forKey: Preference.agreeLicenseKey)
    
}
