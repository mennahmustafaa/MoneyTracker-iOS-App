//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI
import Supabase

/// App entry point; hosts `ContentView` as the root.
@main
struct MoneyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { SupabaseManager.shared.handle($0) }
        }
    }
}
