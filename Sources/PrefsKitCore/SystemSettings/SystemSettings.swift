//
//  SystemSettings.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-11-12.
//

import Foundation

public enum SystemSettings {
    /// Launches System Settings, optionally opening the specified panel.
    public static func launch(panel: Panel? = nil) {
        let command = launchCommand(panel: panel)
        
        // launch
        let p = Process()
        let shellExecutablePath = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        p.executableURL = URL(fileURLWithPath: shellExecutablePath)
        p.arguments = ["-cl", command]
        do { try p.run() }
        catch { print(error.localizedDescription) }
    }
    
    static func launchCommand(panel: Panel? = nil) -> String {
        // see: https://gist.github.com/rmcdongit/f66ff91e0dad78d4d6346a75ded4b751
        // two methods to launch System Settings:
        // - open -b com.apple.systempreferences /System/Library/PreferencePanes/Security.prefPane
        // - open "x-apple.systempreferences:com.apple.preference.security"
        
        // prefer bundle ID over bundle name where possible, since bundle ID allows sub-panel selection
        if let panel {
            if let bundleID = panel.bundleID {
                return "open \"x-apple.systempreferences:\(bundleID)\""
            } else {
                return "open -b com.apple.systempreferences \(panel.bundleName)"
            }
        } else {
            return #"open "x-apple.systempreferences""#
        }
    }
}
