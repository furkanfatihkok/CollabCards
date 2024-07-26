//
//  Crashlytics.swift
//  CollabCards
//
//  Created by FFK on 25.07.2024.
//

import Foundation
import FirebaseCrashlytics

extension Crashlytics {
    static func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    static func setCustomValue(_ value: Any, forkey key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
}
