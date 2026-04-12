//
//  NewTransactionSheet.swift
//  MoneyTracker
//

import SwiftUI

/// Form sheet for a new income or expense; updates `BudgetViewModel` on submit.
struct NewTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BudgetViewModel

    @State private var isExpenseSelected = true
    @State private var amountText = ""
    @State private var descriptionText = ""
    @State private var iconEmoji = "💰"
    @State private var category = ""
    @State private var paymentMethod: PaymentChoice = .card
    @State private var date = Date()
    @State private var notes = ""
    @State private var isRecurring = false
    @State private var showEmojiPicker = false
    @FocusState private var focusedField: Field?

    private enum Field {
        case amount, description, notes
    }

    private enum PaymentChoice: String, CaseIterable {
        case cash = "Cash"
        case card = "Card"
        case wallet = "Wallet"
    }

    private static let incomeCategories = ["Salary", "Freelance", "Investment", "Other"]
    private static let expenseCategories = ["Food", "Housing", "Transport", "Fun", "Shopping", "Health", "Entertainment", "Other"]

    private static let emojiColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    private static let emojiChoices: [String] = [
        "💰", "💵", "💼", "📈", "💳", "🏦",
        "🛒", "🎬", "☕", "🛍️", "🚗", "🍽️",
        "⚡", "⛽", "🅿️", "🏠", "🎁", "📱",
        "✈️", "🏥", "💊", "🎓", "🎯", "❤️",
        "🧾", "💸", "🪙", "📊", "🛟", "🎮"
    ]

    private var activeCategories: [String] {
        isExpenseSelected ? Self.expenseCategories : Self.incomeCategories
    }

    private var parsedAmount: Double? {
        let cleaned = amountText.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    private var canSubmit: Bool {
        (parsedAmount ?? 0) > 0
    }

    var body: some View {
        VStack(spacing: 0) {
            dragHandle
            headerBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    transactionTypeSegment
                    labeledField(title: "AMOUNT") {
                        amountField
                    }
                    labeledField(title: "DESCRIPTION") {
                        descriptionField
                    }
                    labeledField(title: "ICON EMOJI") {
                        emojiRow
                    }
                    labeledField(title: "CATEGORY") {
                        categoryChips
                    }
                    labeledField(title: "PAYMENT METHOD") {
                        paymentMethodRow
                    }
                    labeledField(title: "DATE") {
                        dateField
                    }
                    recurringToggle
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
        .onChange(of: isExpenseSelected) { _, _ in
            let valid = isExpenseSelected ? Self.expenseCategories : Self.incomeCategories
            if !valid.contains(category) {
                category = ""
                iconEmoji = "💰"
            }
        }
    }

    private var dragHandle: some View {
        Capsule()
            .fill(Color.formPlaceholder)
            .frame(width: 36, height: 3.98438)
            .padding(.top, 8)
    }

    private var headerBar: some View {
        HStack(alignment: .center) {
            Text("New Transaction")
                .font(.inter(size: 28, weight: .bold))
                .kerning(0.38281)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                dismiss()
            } label: {
                Image("cancelIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .frame(width: 31.99219, height: 31.99219)
                    .background(Color.segmentTrackBackground)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 19.99219)
        .padding(.top, 4)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
    }

    private var transactionTypeSegment: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Income", isSelected: !isExpenseSelected) {
                isExpenseSelected = false
            }
            segmentButton(title: "Expense", isSelected: isExpenseSelected) {
                isExpenseSelected = true
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .background(Color.segmentTrackBackground)
        .cornerRadius(8)
    }

    private func segmentButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.inter(size: 13, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .black : Color.formLabelMuted)
                .frame(maxWidth: .infinity)
                .padding(.top, 10.48438)
                .padding(.bottom, 8.98438)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.tabBarBackground : Color.clear)
                        .shadow(color: isSelected ? Color.black.opacity(0.08) : .clear, radius: 1, x: 0, y: 1)
                )
        }
        .buttonStyle(.plain)
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

    private var descriptionField: some View {
        HStack {
            TextField("", text: $descriptionText, prompt: Text("e.g., Groceries").foregroundColor(Color.formPlaceholder))
                .font(.inter(size: 17))
                .foregroundColor(.black)
                .focused($focusedField, equals: .description)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
        .background(Color.formFieldFill)
        .cornerRadius(10)
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

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(activeCategories, id: \.self) { name in
                    let selected = category == name
                    Button {
                        category = name
                        iconEmoji = Self.suggestedEmoji(category: name, isExpense: isExpenseSelected)
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

    private var paymentMethodRow: some View {
        HStack(spacing: 8) {
            ForEach(PaymentChoice.allCases, id: \.self) { choice in
                paymentChip(choice)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func paymentChip(_ choice: PaymentChoice) -> some View {
        let selected = paymentMethod == choice
        return Button {
            paymentMethod = choice
        } label: {
            Text(choice.rawValue)
                .font(.inter(size: 15, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(selected ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.top, 10.5)
                .padding(.bottom, 13)
                .background(selected ? Color.black : Color.formFieldFill)
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }

    private var dateField: some View {
        HStack {
            DatePicker(
                "",
                selection: $date,
                displayedComponents: .date
            )
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

    private var recurringToggle: some View {
        Toggle(isOn: $isRecurring) {
            Text("Recurring transaction")
                .font(.inter(size: 17))
                .foregroundColor(.black)
        }
        .tint(Color.black)
        .padding(.vertical, 4)
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
            Text("Add Transaction")
                .font(.inter(size: 17, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 15.48438)
                .padding(.bottom, 15.96094)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 4)
                .shadow(color: Color.black.opacity(0.1), radius: 7.5, x: 0, y: 10)
        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
        .opacity(canSubmit ? 1 : 0.45)
        .padding(.top, 8)
    }

    private var emojiPickerSheet: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Self.emojiColumns, spacing: 12) {
                    ForEach(Self.emojiChoices, id: \.self) { e in
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

    private static func suggestedEmoji(category: String, isExpense: Bool) -> String {
        if isExpense {
            switch category {
            case "Food": return "🍽️"
            case "Housing": return "🏠"
            case "Transport": return "🚗"
            case "Fun": return "🎉"
            case "Shopping": return "🛍️"
            case "Health": return "💊"
            case "Entertainment": return "🎬"
            case "Other": return "💳"
            default: return "💰"
            }
        } else {
            switch category {
            case "Salary": return "💵"
            case "Freelance": return "💼"
            case "Investment": return "📈"
            case "Other": return "💰"
            default: return "💰"
            }
        }
    }

    private func submit() {
        guard let amt = parsedAmount, amt > 0 else { return }
        let title = descriptionText.trimmingCharacters(in: .whitespaces)
        let noteStr = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let cat = category.isEmpty ? "Other" : category
        viewModel.addTransaction(
            amount: amt,
            isIncome: !isExpenseSelected,
            title: title.isEmpty ? (isExpenseSelected ? "Expense" : "Income") : title,
            icon: iconEmoji,
            category: cat,
            paymentMethod: paymentMethod.rawValue,
            date: date,
            notes: noteStr.isEmpty ? nil : noteStr,
            isRecurring: isRecurring
        )
        dismiss()
    }
}

#Preview {
    NewTransactionSheet(viewModel: BudgetViewModel(store: AppDataStore.preview))
}
