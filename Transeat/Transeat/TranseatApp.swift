//
//  TranseatApp.swift
//  Transeat
//
//  Created by Jonathan Basuki on 01/07/26.
//

import SwiftUI
import SwiftData

@main
struct TranseatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: UserProfile.self)
    }
}

