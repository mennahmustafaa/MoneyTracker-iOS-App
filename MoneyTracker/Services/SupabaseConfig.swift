//
//  SupabaseConfig.swift
//  MoneyTracker
//

import Foundation

/// Project **MoneyTracker** (`sajyqeindlbtzqrmydvs`). Dashboard → Settings → API.
enum SupabaseConfig {
    static let supabaseURL = URL(string: "https://sajyqeindlbtzqrmydvs.supabase.co")!

    /// **Anon** / **publishable** key (never use `service_role` in the app).
    /// 1. Supabase Dashboard → Project Settings → API → **Publishable** (or **anon**) key.
    /// 2. Paste it here, **or** set build setting `INFOPLIST_KEY_SUPABASE_ANON_KEY` / Info.plist `SUPABASE_ANON_KEY`.
    static let supabaseAnonKey: String = {
        if let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
           !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return key.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let env = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"],
           !env.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return env.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return SupabaseConfigEmbeddedKey.value
    }()
}

/// Replace with your key for local runs; prefer Info.plist for CI/secrets.
private enum SupabaseConfigEmbeddedKey {
    static let value = "sb_publishable_RE_IR2-SZvV1NEh7W2l0Yw_l4cYxVBM"
}
