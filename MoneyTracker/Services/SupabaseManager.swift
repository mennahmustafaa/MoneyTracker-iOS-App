//
//  SupabaseManager.swift
//  MoneyTracker
//

import Foundation
import Supabase

enum SupabaseManager {
    /// Safe to reference from any isolation context (e.g. `SessionViewModel` init defaults, previews).
    static let shared = SupabaseClient(
        supabaseURL: SupabaseConfig.supabaseURL,
        supabaseKey: SupabaseConfig.supabaseAnonKey
    )
}
