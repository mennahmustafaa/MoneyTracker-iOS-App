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

    private static let categories = ["Food", "Fun", "Transport", "Housing", "Freelance", "Other"]
    private static let emojiChoices = ["💰", "🛒", "🎬", "☕", "🛍️", "🚗", "💼", "🍽️", "⚡", "⛽", "🅿️", "🏠", "🎁", "💳"]

    private var parsedAmount: Double? {
        let cleaned = amountText.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    private var canSubmit: Bool {
        (parsedAmount ?? 0) > 0
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    transactionTypeSegment
                    labeledField(title: "Amount") {
                        amountField
                    }
                    labeledField(title: "Description") {
                        descriptionField
                    }
                    labeledField(title: "Icon Emoji") {
                        emojiRow
                    }
                    labeledField(title: "Category") {
                        categoryField
                    }
                    labeledField(title: "Payment Method") {
                        paymentMethodRow
                    }
                    labeledField(title: "Date") {
                        dateField
                    }
                    labeledField(title: "Notes (Optional)") {
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
    }

    private var headerBar: some View {
        ZStack(alignment: .center) {
            Text("New Transaction")
                .font(.inter(size: 28, weight: .bold))
                .kerning(0.38281)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
            HStack {
                Spacer()
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
        }
        .padding(.horizontal, 19.99219)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, minHeight: 52, alignment: .center)
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
                    Group {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.tabBarBackground)
                                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 1)
                        } else {
                            Color.clear
                        }
                    }
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
                    .font(.inter(size: 32))
                    .kerning(0.40625)
                    .multilineTextAlignment(.center)
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

    private var categoryField: some View {
        Menu {
            ForEach(Self.categories, id: \.self) { c in
                Button(c) { category = c }
            }
        } label: {
            HStack {
                Text(category.isEmpty ? "Select category" : category)
                    .font(.inter(size: 17))
                    .foregroundColor(category.isEmpty ? Color.formPlaceholder : .black)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.formLabelMuted)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 43.5, maxHeight: 43.5, alignment: .leading)
            .background(Color.formFieldFill)
            .cornerRadius(10)
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
                .background(selected ? Color.backgroundBlack : Color.formFieldFill)
                .cornerRadius(10)
                .shadow(
                    color: selected ? Color.black.opacity(0.1) : .clear,
                    radius: selected ? 2 : 0,
                    x: 0,
                    y: selected ? 2 : 0
                )
                .shadow(
                    color: selected ? Color.black.opacity(0.1) : .clear,
                    radius: selected ? 3 : 0,
                    x: 0,
                    y: selected ? 4 : 0
                )
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
                .background(Color.backgroundBlack)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 4)
                .shadow(color: .black.opacity(0.1), radius: 7.5, x: 0, y: 10)
        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
        .opacity(canSubmit ? 1 : 0.45)
        .padding(.top, 8)
    }

    private var emojiPickerSheet: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 52))], spacing: 12) {
                    ForEach(Self.emojiChoices, id: \.self) { e in
                        Button {
                            iconEmoji = e
                            showEmojiPicker = false
                        } label: {
                            Text(e)
                                .font(.system(size: 36))
                                .frame(maxWidth: .infinity, minHeight: 52)
                        }
                    }
                }
                .padding()
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

    private func submit() {
        guard let amt = parsedAmount, amt > 0 else { return }
        let title = descriptionText.trimmingCharacters(in: .whitespaces)
        viewModel.addTransaction(
            amount: amt,
            isIncome: !isExpenseSelected,
            title: title.isEmpty ? (isExpenseSelected ? "Expense" : "Income") : title,
            icon: iconEmoji,
            category: category.isEmpty ? "Other" : category,
            paymentMethod: paymentMethod.rawValue,
            date: date
        )
        dismiss()
    }
}

#Preview {
    NewTransactionSheet(viewModel: BudgetViewModel())
}
