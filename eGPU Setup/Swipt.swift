//
//  Swipt.swift
//  eGPU Setup
//
//  Created by Mayank Kumar on 8/1/18.
//  Copyright © 2018 Mayank Kumar. All rights reserved.
//

import Swipt

/// Defines access for Swipt framework.
class Swipt {
    
    /// Singleton instance of `SwiptManager`.
    private static var swiptManager: SwiptManager?
    
    /// Retrieves an instance of `SwiptManager`.
    ///
    /// - Returns: A `SwiptManager` instance.
    static func instance() -> SwiptManager {
        guard let manager = swiptManager else {
            swiptManager = SwiptManager()
            return swiptManager!
        }
        return manager
    }
    
}
