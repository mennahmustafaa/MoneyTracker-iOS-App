//
//  NewDonationSheet.swift
//  MoneyTracker
//
//  Modal form to add a donation (sheet from `MainTabContainerView`).
//

import SwiftUI

/// Add or edit a donation; same layout and styling as the rest of the app.
struct NewDonationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DonateViewModel

    /// When set, the sheet pre-fills from this record and saves via `updateDonation`.
    var editingDonation: DonationRecord? = nil

    @State private var amountText = ""
    @State private var organizationText = ""
    @State private var category = ""
    @State private var iconEmoji = "❤️"
    @State private var isRecurring = false
    @State private var date = Date()
    @State private var notes = ""
    @State private var showEmojiPicker = false
    @FocusState private var focusedField: Field?

    private enum Field {
        case amount, organization, notes
    }

    private static let categories = ["Healthcare", "Education", "Hunger Relief", "Animal Welfare", "Other"]

    private static let categoryDefaultEmoji: [String: String] = [
        "Healthcare": "🏥",
        "Education": "📚",
        "Hunger Relief": "🍞",
        "Animal Welfare": "🐾",
        "Other": "❤️"
    ]

    private static let emojiColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    private static let donationEmojiChoices: [String] = [
        "❤️", "🏥", "📚", "🍞", "🐾", "🌍",
        "🙏", "💉", "🎗️", "🤝", "💊", "🥫",
        "🧸", "✨", "💝", "🫶", "🏠", "👶",
        "🩺", "📖", "🌾", "🐕", "⭐️", "💐"
    ]

    private var parsedAmount: Double? {
        let cleaned = amountText.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    private var canSubmit: Bool {
        (parsedAmount ?? 0) > 0
    }

    private var sheetTitle: String {
        editingDonation == nil ? "New Donation" : "Edit Donation"
    }

    private var primaryButtonTitle: String {
        editingDonation == nil ? "Add Donation" : "Save Changes"
    }

    var body: some View {
        VStack(spacing: 0) {
            dragHandle
            headerBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    labeledField(title: "AMOUNT") {
                        amountField
                    }
                    labeledField(title: "ORGANIZATION") {
                        organizationField
                    }
                    labeledField(title: "CATEGORY") {
                        categoryChips
                    }
                    labeledField(title: "ICON EMOJI") {
                        emojiRow
                    }
                    recurringRow
                    labeledField(title: "DATE") {
                        dateField
                    }
                    labeledField(title: "NOTES (OPTIONAL)") {
                        notesField
                    }
                    addButton
                }
                .padding(.horizontal, 19.99219)
                .padding(.bottom, 24)
            }
        }
        .background(Color.tabBarBackground)
        .sheet(isPresented: $showEmojiPicker) {
            emojiPickerSheet
        }
        .onAppear {
            if let d = editingDonation {
                applyEditingDonation(d)
            }
        }
    }

    private func applyEditingDonation(_ d: DonationRecord) {
        amountText = Self.formatAmount(d.amount)
        organizationText = d.organization
        if Self.categories.contains(d.cause) {
            category = d.cause
        } else {
            category = "Other"
        }
        let trimmed = d.iconEmoji?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        iconEmoji = trimmed.isEmpty ? "❤️" : trimmed
        isRecurring = (d.frequency == "monthly")
        date = Self.dateFromDonationDisplayString(d.date)
        notes = ""
    }

    private static func formatAmount(_ value: Double) -> String {
        if value == floor(value) {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }

    /// Parses dates stored as `"MMM d"` (e.g. `Dec 1`) using the current year.
    private static func dateFromDonationDisplayString(_ s: String) -> Date {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d"
        guard let partial = f.date(from: s) else { return Date() }
        let cal = Calendar.current
        let year = cal.component(.year, from: Date())
        var comps = cal.dateComponents([.month, .day], from: partial)
        comps.year = year
        return cal.date(from: comps) ?? Date()
    }

    private var dragHandle: some View {
        Capsule()
            .fill(Color.formPlaceholder)
            .frame(width: 36, height: 3.98438)
            .padding(.top, 8)
    }

    private var headerBar: some View {
        HStack(alignment: .center) {
            Text(sheetTitle)
                .font(.inter(size: 28, weight: .bold))
                .kerning(0.38281)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.segmentTrackBackground)
                    Image("cancelIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 19.99219)
        .frame(maxWidth: .infinity, minHeight: 42, maxHeight: 42, alignment: .center)
    }

    private func labeledField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.inter(size: 13))
                .kerning(0.24883)
                .foregroundColor(Color.formLabelMuted)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var amountField: some View {
        HStack {
            TextField("", text: $amountText, prompt: Text("0.00").foregroundColor(Color.formPlaceholder))
                .font(.inter(size: 17))
                .foregroundColor(.black)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .amount)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
        .background(Color.formFieldFill)
        .cornerRadius(10)
    }

    private var organizationField: some View {
        HStack {
            TextField("", text: $organizationText, prompt: Text("e.g., Red Cross").foregroundColor(Color.formPlaceholder))
                .font(.inter(size: 17))
                .foregroundColor(.black)
                .focused($focusedField, equals: .organization)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
        .background(Color.formFieldFill)
        .cornerRadius(10)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Self.categories, id: \.self) { name in
                    let selected = category == name
                    Button {
                        category = name
                        iconEmoji = Self.categoryDefaultEmoji[name] ?? "❤️"
                    } label: {
                        Text(name)
                            .font(.inter(size: 14, weight: .semibold))
                            .foregroundColor(selected ? .white : .black)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(selected ? Color.black : Color.formFieldFill)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var emojiRow: some View {
        Button {
            showEmojiPicker = true
        } label: {
            HStack {
                Text(iconEmoji)
                    .font(.system(size: 32))
                    .foregroundColor(.black)
                Spacer()
                Text("Tap to change")
                    .font(.inter(size: 15))
                    .foregroundColor(Color.formPlaceholder)
            }
            .padding(.horizontal, 15.98438)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 71.97656, maxHeight: 71.97656, alignment: .center)
            .background(Color.formFieldFill)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }

    private var emojiPickerSheet: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Self.emojiColumns, spacing: 12) {
                    ForEach(Self.donationEmojiChoices, id: \.self) { e in
                        Button {
                            iconEmoji = e
                            showEmojiPicker = false
                        } label: {
                            Text(e)
                                .font(.system(size: 32))
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Choose emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showEmojiPicker = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private var recurringRow: some View {
        HStack(alignment: .center) {
            Text("Recurring Donation")
                .font(.inter(size: 17))
                .foregroundColor(.black)
            Spacer()
            Toggle("", isOn: $isRecurring)
                .labelsHidden()
                .tint(Color.backgroundBlack)
        }
        .padding(.horizontal, 4)
    }

    private var dateField: some View {
        HStack {
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .tint(.black)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
        .background(Color.formFieldFill)
        .cornerRadius(10)
    }

    private var notesField: some View {
        TextField("", text: $notes, prompt: Text("Add any notes...").foregroundColor(Color.formPlaceholder), axis: .vertical)
            .font(.inter(size: 17))
            .foregroundColor(.black)
            .lineLimit(3 ... 6)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 100.42969, maxHeight: 100.42969, alignment: .topLeading)
            .background(Color.formFieldFill)
            .cornerRadius(10)
            .focused($focusedField, equals: .notes)
    }

    private var addButton: some View {
        Button {
            submit()
        } label: {
            Text(primaryButtonTitle)
                .font(.inter(size: 17, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 15.48438)
                .padding(.bottom, 15.96094)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
        .opacity(canSubmit ? 1 : 0.45)
        .padding(.top, 8)
    }

    private func submit() {
        guard let amt = parsedAmount, amt > 0 else { return }
        let trimmedEmoji = iconEmoji.trimmingCharacters(in: .whitespacesAndNewlines)
        let cat = category.isEmpty ? "Other" : category
        let emoji = trimmedEmoji.isEmpty ? nil : trimmedEmoji
        if let existing = editingDonation {
            viewModel.updateDonation(
                id: existing.id,
                amount: amt,
                organization: organizationText,
                category: cat,
                isRecurring: isRecurring,
                date: date,
                iconEmoji: emoji
            )
        } else {
            viewModel.addDonation(
                amount: amt,
                organization: organizationText,
                category: cat,
                isRecurring: isRecurring,
                date: date,
                iconEmoji: emoji
            )
        }
        dismiss()
    }
}

#Preview {
    NewDonationSheet(viewModel: DonateViewModel(store: AppDataStore.preview), editingDonation: nil)
}
