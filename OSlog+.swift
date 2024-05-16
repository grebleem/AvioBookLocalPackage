//
//  OSlog+.swift
//  AvioBookPackageLocal
//
//  Created by Bastiaan Meelberg on 11/05/2024.
//

import Foundation
import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let viewModel = Logger(subsystem: subsystem, category: "viewModel")
}
