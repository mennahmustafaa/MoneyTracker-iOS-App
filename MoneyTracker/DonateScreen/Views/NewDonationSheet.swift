//
//  NewDonationSheet.swift
//  MoneyTracker
//
//  Modal form to add a donation (sheet from `DonateScreenContent`).
//

import SwiftUI

/// New donation form; requires a positive amount to enable submit.
struct NewDonationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DonateViewModel

    @State private var amountText = ""
    @State private var organizationText = ""
    @State private var category = ""
    @State private var isRecurring = false
    @State private var date = Date()
    @State private var notes = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case amount, organization, notes
    }

    private static let categories = ["Healthcare", "Education", "Hunger Relief", "Animal Welfare", "Other"]

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
                    labeledField(title: "AMOUNT") {
                        amountField
                    }
                    labeledField(title: "ORGANIZATION") {
                        organizationField
                    }
                    labeledField(title: "CATEGORY") {
                        categoryField
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
    }

    private var dragHandle: some View {
        Capsule()
            .fill(Color.formPlaceholder)
            .frame(width: 36, height: 3.98438)
            .padding(.top, 8)
    }

    private var headerBar: some View {
        HStack(alignment: .center) {
            Text("New Donation")
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
            Text("Add Donation")
                .font(.inter(size: 17, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.top, 15.48438)
                .padding(.bottom, 15.96094)
                .background(Color.black)
                .cornerRadius(14)

        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
        .opacity(canSubmit ? 1 : 0.45)
        .padding(.top, 8)
    }

    private func submit() {
        guard let amt = parsedAmount, amt > 0 else { return }
        viewModel.addDonation(
            amount: amt,
            organization: organizationText,
            category: category,
            isRecurring: isRecurring,
            date: date
        )
        dismiss()
    }
}

#Preview {
    NewDonationSheet(viewModel: DonateViewModel())
}
