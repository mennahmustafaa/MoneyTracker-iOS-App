# MoneyTracker

MoneyTracker is an iOS personal finance app built with SwiftUI.  
It helps users track transactions, monitor budgets, manage savings goals, and record donations in one place.

## Features

- Budget dashboard with balance, income, and expense summary
- Transaction history with categories, dates, income/expense state, and delete confirmation
- Shopping tab with shopping list and wishlist management
- Goals tab with progress cards, add goal flow, add-to-goal updates, and deletion
- Donate tab with donation records, editable donations, cause impact tracking, and summary cards
- Profile tab with account details, financial overview, activity, and log out
- Authentication with Supabase (email/password sign in and sign up)
- Onboarding + splash experience and lightweight app-wide animations

## Tech Stack

- Swift 6
- SwiftUI
- Combine
- Supabase Swift SDK
- Xcode project-based iOS app architecture (MVVM-style per feature)

## Project Structure

Key folders inside `MoneyTracker/`:

- `Auth/` - Sign in, sign up, session handling
- `Budget/` - Budget summary, transaction entry, charts, home tab components
- `HistoryScreen/` - Full transaction history tab
- `ShoppingScreen/` - Shopping list and wishlist flows
- `GoalsScreen/` - Goal tracking and contribution flows
- `DonateScreen/` - Donation tracking and impact views
- `ProfileScreen/` - User profile and account overview
- `Services/` - App store persistence + Supabase client/config
- `Utils/` - Shared styling, formatting, and motion helpers

## Getting Started

### 1) Requirements

- macOS + Xcode (latest stable recommended)
- iOS Simulator or physical iPhone

### 2) Open the project

Open:

- `MoneyTracker.xcodeproj`

### 3) Configure Supabase

The app reads the Supabase anon key from:

1. `Info.plist` key: `SUPABASE_ANON_KEY` (recommended), or
2. Environment variable: `SUPABASE_ANON_KEY`, or
3. Embedded fallback in `MoneyTracker/Services/SupabaseConfig.swift`

Supabase project URL is configured in `SupabaseConfig.swift`.

### 4) Run

- Select the `MoneyTracker` scheme
- Choose a simulator/device
- Run with `Cmd + R`
