//
//  AppDataStore.swift
//  MoneyTracker
//
//  Local JSON persistence in Application Support. Replace disk I/O with Supabase
//  (same public methods) once auth is integrated — keep `StoredTransaction` fields aligned with your table.
//

import Combine
import Foundation

private struct PersistedPayload: Codable {
    var schemaVersion: Int
    var transactions: [StoredTransaction]
    var shoppingItems: [ShoppingItem]
    var goals: [GoalProgressItem]
    var donations: [DonationRecord]
    var causes: [ImpactCause]
    var quote: String
    var quoteAuthor: String
}

@MainActor
final class AppDataStore: ObservableObject {
    private static let schemaVersion = 1
    private let persistenceURL: URL?
    private let disablePersistence: Bool

    @Published private(set) var transactions: [StoredTransaction] = []
    @Published private(set) var shoppingItems: [ShoppingItem] = []
    @Published private(set) var goals: [GoalProgressItem] = []
    @Published private(set) var donations: [DonationRecord] = []
    @Published private(set) var causes: [ImpactCause] = []
    @Published private(set) var quote: String = ""
    @Published private(set) var quoteAuthor: String = ""

    /// Live app: persist to disk. Preview: no I/O.
    init(disablePersistence: Bool = false) {
        self.disablePersistence = disablePersistence
        if disablePersistence {
            persistenceURL = nil
            applySeedData()
            return
        }
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            persistenceURL = nil
            applySeedData()
            return
        }
        let dir = base.appendingPathComponent("MoneyTracker", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        persistenceURL = dir.appendingPathComponent("app_state.json", isDirectory: false)
        load()
    }

    // MARK: - Budget / History

    var budgetSummary: BudgetSummary {
        let income = transactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
        let balance = transactions.reduce(0) { $0 + $1.amount }
        return BudgetSummary(currentBalance: balance, income: income, expenses: expenses)
    }

    func budgetRecordRows(limit: Int) -> [BudgetTransactionRecord] {
        let sorted = transactions.sorted { $0.occurredAt > $1.occurredAt }
        return sorted.prefix(limit).map(Self.mapToBudgetRecord)
    }

    func historyRows(filter: HistoryFilter) -> [HistoryTransaction] {
        let rows = transactions
            .sorted { $0.occurredAt > $1.occurredAt }
            .map(Self.mapToHistoryTransaction)
        switch filter {
        case .all:
            return rows
        case .recurring:
            return rows.filter(\.isRecurring)
        }
    }

    func addTransaction(
        amount: Double,
        isIncome: Bool,
        title: String,
        icon: String,
        category: String,
        paymentMethod: String,
        date: Date,
        notes: String?,
        isRecurring: Bool = false
    ) {
        let signed = isIncome ? amount : -amount
        let t = StoredTransaction(
            id: UUID(),
            occurredAt: date,
            title: title,
            category: category,
            paymentMethod: paymentMethod,
            icon: icon,
            notes: notes.flatMap { $0.isEmpty ? nil : $0 },
            amount: signed,
            isRecurring: isRecurring
        )
        transactions.insert(t, at: 0)
        save()
    }

    func deleteTransaction(id: UUID) {
        transactions.removeAll { $0.id == id }
        save()
    }

    // MARK: - Shopping

    func setShoppingItems(_ items: [ShoppingItem]) {
        shoppingItems = items
        save()
    }

    // MARK: - Goals

    func setGoals(_ items: [GoalProgressItem]) {
        goals = items
        save()
    }

    // MARK: - Donate

    func addDonation(
        amount: Double,
        organization: String,
        category: String,
        isRecurring: Bool,
        date: Date,
        iconEmoji: String?
    ) {
        let formatter = Self.donationDateFormatter
        let dateStr = formatter.string(from: date)
        let frequency = isRecurring ? "monthly" : "one-time"
        let org = organization.trimmingCharacters(in: .whitespaces)
        let cause = category.trimmingCharacters(in: .whitespaces)
        let record = DonationRecord(
            organization: org.isEmpty ? "Donation" : org,
            cause: cause.isEmpty ? "General" : cause,
            date: dateStr,
            frequency: frequency,
            amount: amount,
            iconEmoji: iconEmoji
        )
        donations.insert(record, at: 0)
        bumpCauseForDonation(cause: record.cause, addedAmount: amount)
        save()
    }

    // MARK: - Profile aggregates

    func paymentMethodTotals() -> [(name: String, amount: Double)] {
        var sums: [String: Double] = [:]
        for t in transactions where t.amount < 0 {
            let key = t.paymentMethod.isEmpty ? "Other" : t.paymentMethod
            sums[key, default: 0] += abs(t.amount)
        }
        return sums.map { ($0.key, $0.value) }.sorted { $0.name < $1.name }
    }

    func transactionCountThisMonth(reference: Date = Date()) -> Int {
        let cal = Calendar.current
        return transactions.filter { cal.isDate($0.occurredAt, equalTo: reference, toGranularity: .month) }.count
    }

    // MARK: - Private

    private static let donationDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d"
        return f
    }()

    private static let budgetDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEE, MMM d"
        return f
    }()

    private static let historyDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

    private static func mapToBudgetRecord(_ t: StoredTransaction) -> BudgetTransactionRecord {
        BudgetTransactionRecord(
            id: t.id,
            icon: t.icon,
            title: t.title,
            date: budgetDateFormatter.string(from: t.occurredAt),
            category: t.category,
            paymentMethod: t.paymentMethod,
            amount: t.amount
        )
    }

    private static func mapToHistoryTransaction(_ t: StoredTransaction) -> HistoryTransaction {
        HistoryTransaction(
            id: t.id,
            name: t.title,
            category: t.category,
            date: historyDateFormatter.string(from: t.occurredAt),
            amount: abs(t.amount),
            isIncome: t.amount > 0,
            isRecurring: t.isRecurring
        )
    }

    private func bumpCauseForDonation(cause: String, addedAmount: Double) {
        guard let idx = causes.firstIndex(where: { $0.name.caseInsensitiveCompare(cause) == .orderedSame }) else { return }
        let c = causes[idx]
        let newAmount = c.amount + addedAmount
        let denom = max(newAmount * 2.5, 1)
        let progress = min(1, newAmount / denom)
        causes[idx] = ImpactCause(id: c.id, name: c.name, amount: newAmount, progress: progress)
    }

    private func load() {
        guard let url = persistenceURL,
              FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url)
        else {
            applySeedData()
            save()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let payload = try? decoder.decode(PersistedPayload.self, from: data) else {
            applySeedData()
            save()
            return
        }
        transactions = payload.transactions
        shoppingItems = payload.shoppingItems
        goals = payload.goals
        donations = payload.donations
        causes = payload.causes
        quote = payload.quote
        quoteAuthor = payload.quoteAuthor
    }

    private func save() {
        guard !disablePersistence, let url = persistenceURL else { return }
        let payload = PersistedPayload(
            schemaVersion: Self.schemaVersion,
            transactions: transactions,
            shoppingItems: shoppingItems,
            goals: goals,
            donations: donations,
            causes: causes,
            quote: quote,
            quoteAuthor: quoteAuthor
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(payload) else { return }
        try? data.write(to: url, options: [.atomic])
    }

    private func applySeedData() {
        transactions = Self.seedTransactions
        shoppingItems = Self.seedShoppingItems
        goals = Self.seedGoals
        donations = Self.seedDonations
        causes = Self.seedCauses
        quote = "\"No one has ever become poor by giving.\""
        quoteAuthor = "— Anne Frank"
    }

    private static let seedShoppingItems: [ShoppingItem] = [
        ShoppingItem(title: "Milk", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "Bread", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "Eggs", segment: .shoppingList, isCompleted: true),
        ShoppingItem(title: "Coffee", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "Apples", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "New Blender", segment: .wishlist, isCompleted: false),
        ShoppingItem(title: "Office Chair", segment: .wishlist, isCompleted: false)
    ]

    private static let seedGoals: [GoalProgressItem] = [
        GoalProgressItem(icon: "✈️", title: "Trip to Japan", deadlineText: "Deadline passed", currentAmount: 1200, targetAmount: 3000),
        GoalProgressItem(icon: "💻", title: "New Laptop", deadlineText: "Deadline passed", currentAmount: 800, targetAmount: 1500),
        GoalProgressItem(icon: "🛡️", title: "Emergency Fund", deadlineText: "7 days remaining", currentAmount: 5500, targetAmount: 10000)
    ]

    private static let seedCauses: [ImpactCause] = [
        ImpactCause(name: "Healthcare", amount: 100, progress: 0.38),
        ImpactCause(name: "Education", amount: 75, progress: 0.27),
        ImpactCause(name: "Hunger Relief", amount: 50, progress: 0.2),
        ImpactCause(name: "Animal Welfare", amount: 25, progress: 0.12)
    ]

    private static let seedDonations: [DonationRecord] = [
        DonationRecord(organization: "Red Cross", cause: "Healthcare", date: "Dec 1", frequency: "yearly", amount: 100),
        DonationRecord(organization: "Local Food Bank", cause: "Hunger Relief", date: "Dec 15", frequency: "monthly", amount: 50),
        DonationRecord(organization: "Animal Shelter", cause: "Animal Welfare", date: "Dec 20", frequency: "yearly", amount: 25),
        DonationRecord(organization: "Education Fund", cause: "Education", date: "Nov 20", frequency: "yearly", amount: 75)
    ]

    private static var seedTransactions: [StoredTransaction] {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "America/Los_Angeles") ?? .current
        func date(_ y: Int, _ m: Int, _ d: Int) -> Date {
            cal.date(from: DateComponents(year: y, month: m, day: d)) ?? Date()
        }
        return [
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 7), title: "Groceries", category: "Food", paymentMethod: "Card", icon: "🛒", notes: nil, amount: -140, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 7), title: "Movie & Dinner", category: "Fun", paymentMethod: "Card", icon: "🎬", notes: nil, amount: -75, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 7), title: "Coffee Shop", category: "Food", paymentMethod: "Cash", icon: "☕", notes: nil, amount: -45, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 6), title: "Shopping", category: "Fun", paymentMethod: "Card", icon: "🛍️", notes: nil, amount: -250, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 5), title: "Uber", category: "Transport", paymentMethod: "Wallet", icon: "🚗", notes: nil, amount: -45, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 5), title: "Freelance Work", category: "Freelance", paymentMethod: "Wallet", icon: "💼", notes: nil, amount: 600, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 4), title: "Restaurant", category: "Food", paymentMethod: "Card", icon: "🍽️", notes: nil, amount: -95, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 4), title: "Electric Bill", category: "Housing", paymentMethod: "Card", icon: "⚡", notes: nil, amount: -85, isRecurring: true),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 3), title: "Gas", category: "Transport", paymentMethod: "Card", icon: "⛽", notes: nil, amount: -65, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 3), title: "Parking", category: "Transport", paymentMethod: "Cash", icon: "🅿️", notes: nil, amount: -40, isRecurring: false),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 4, 1), title: "Salary", category: "Salary", paymentMethod: "Card", icon: "💵", notes: nil, amount: 5000, isRecurring: true),
            StoredTransaction(id: UUID(), occurredAt: date(2026, 3, 28), title: "Rent Payment", category: "Housing", paymentMethod: "Card", icon: "🏠", notes: nil, amount: -1200, isRecurring: true)
        ]
    }
}

extension AppDataStore {
    /// In-memory seeded data for SwiftUI previews (no disk writes).
    static var preview: AppDataStore { AppDataStore(disablePersistence: true) }
}
