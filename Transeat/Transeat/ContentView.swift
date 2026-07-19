//
//  ContentView.swift
//  Transeat
//
//  Created by Gabriella Erlinda on 06/07/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Auto-updating list of every UserProfile currently stored locally.
    @Query(sort: \UserProfileModel.createdAt, order: .reverse) private var storedUsers: [UserProfileModel]

    var body: some View {
        NavigationStack {
            rootView
        }
        .onAppear {
            printStoredUsersDebugList()
        }
    }

    /// Skips onboarding/validation entirely if a profile is already saved
    /// locally — goes straight to HomeView using that profile's data.
    /// While no profile exists yet (still validating pregnancy data), the
    /// Watch app is told to show its "welcome" screen.
    @ViewBuilder
    private var rootView: some View {
        if let existingUser = storedUsers.first {
            HomeView(expectedDueDate: existingUser.expectedDueDate)
        } else {
            OnboardingView()
                .onAppear {
                    print("[ContentView] no saved profile yet — broadcasting 'welcome' to Watch")
                    WatchConnectivityManager.shared.syncContext([
                        "screen": "welcome",
                        "remainingSeconds": 0
                    ])
                }
        }
    }

    /// Debug-only: dumps every saved UserProfile to the console on launch
    /// so you can confirm SwiftData is actually persisting data between
    /// app runs. Not shown anywhere in the UI.
    private func printStoredUsersDebugList() {
        print("========== [DEBUG] Stored UserProfiles: \(storedUsers.count) ==========")
        if storedUsers.isEmpty {
            print("(kosong — belum ada UserProfile yang tersimpan)")
        } else {
            for (index, user) in storedUsers.enumerated() {
                print("""
                [\(index)] name: \(user.name) | age: \(user.age) | edd: \(user.expectedDueDate) \
                | usgProof: \(user.usgProofData != nil ? "\(user.usgProofData!.count) bytes" : "nil") \
                | medicationProof: \(user.medicationProofData != nil ? "\(user.medicationProofData!.count) bytes" : "nil") \
                | createdAt: \(user.createdAt)
                """)
            }
        }
        print("=================================================================")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: UserProfileModel.self, inMemory: true)
}
