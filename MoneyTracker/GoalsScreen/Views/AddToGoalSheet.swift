//
//  AddToGoalSheet.swift
//  MoneyTracker
//

import SwiftUI

/// Bottom sheet to add savings toward one goal (card **+**). Caps at `targetAmount`.
@MainActor
struct AddToGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    let goal: GoalProgressItem
    @ObservedObject var viewModel: GoalsViewModel

    @State private var amountText = ""
    @FocusState private var amountFocused: Bool

    private var parsedAmount: Double? {
        let cleaned = amountText.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    private var canSubmit: Bool {
        (parsedAmount ?? 0) > 0
    }

    private var stepperBinding: Binding<Double> {
        Binding(
            get: { parsedAmount ?? 0 },
            set: { newValue in
                if newValue <= 0 {
                    amountText = ""
                } else {
                    amountText = Self.amountFormatter.string(from: NSNumber(value: newValue)) ?? String(format: "%.2f", newValue)
                }
            }
        )
    }

    private static let amountFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US")
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }()

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.formPlaceholder)
                .frame(width: 36, height: 3.98438)
                .padding(.top, 8)

            HStack(alignment: .center) {
                Text("Add to Goal")
                    .font(.inter(size: 22, weight: .bold))
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
                    .frame(width: 31.99219, height: 31.99219)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 19.99219)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Text(goal.title)
                .font(.inter(size: 15, weight: .semibold))
                .foregroundColor(Color.formLabelMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 19.99219)
                .padding(.bottom, 8)

            VStack(alignment: .leading, spacing: 8) {
                Text("AMOUNT")
                    .font(.inter(size: 13))
                    .kerning(0.24883)
                    .foregroundColor(Color.formLabelMuted)
                HStack(spacing: 12) {
                    TextField("", text: $amountText, prompt: Text("0.00").foregroundColor(Color.formPlaceholder))
                        .font(.inter(size: 17))
                        .foregroundColor(.black)
                        .keyboardType(.decimalPad)
                        .focused($amountFocused, equals: true)
                    Stepper("", value: stepperBinding, in: 0 ... max(goal.targetAmount, 1), step: 10)
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
                .background(Color.formFieldFill)
                .cornerRadius(10)
            }
            .padding(.horizontal, 19.99219)

            Spacer(minLength: 16)

            HStack(spacing: 8) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.inter(size: 17, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 13.49219)
                        .padding(.bottom, 13.96875)
                        .background(Color.formFieldFill)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)

                Button {
                    submit()
                } label: {
                    Text("Add")
                        .font(.inter(size: 17, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 13.49219)
                        .padding(.bottom, 13.96875)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 4)
                        .shadow(color: Color.black.opacity(0.1), radius: 7.5, x: 0, y: 10)
                }
                .buttonStyle(.plain)
                .disabled(!canSubmit)
                .opacity(canSubmit ? 1 : 0.45)
            }
            .padding(.horizontal, 19.99219)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }

    private func submit() {
        guard let amt = parsedAmount, amt > 0 else { return }
        viewModel.addContribution(to: goal.id, amount: amt)
        dismiss()
    }
}

#Preview {
    AddToGoalSheet(
        goal: GoalProgressItem(icon: "✈️", title: "Trip to Japan", deadlineText: "—", currentAmount: 1200, targetAmount: 3000),
        viewModel: GoalsViewModel(store: AppDataStore.preview)
    )
}
