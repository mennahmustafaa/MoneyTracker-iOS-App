//
//  NewGoalSheet.swift
//  MoneyTracker
//

import SwiftUI

/// “Add New Goal” bottom sheet (Inter, two-column footer) from Goals header / card +.
@MainActor
struct NewGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GoalsViewModel

    @State private var nameText = ""
    @State private var targetText = ""
    @State private var deadline = Date()
    @State private var iconText = "🎯"
    @FocusState private var focusedField: Field?

    private enum Field {
        case name, target, icon
    }

    private var parsedTarget: Double? {
        let cleaned = targetText.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    private var canSubmit: Bool {
        let nameOk = !nameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let targetOk = (parsedTarget ?? 0) > 0
        return nameOk && targetOk
    }

    var body: some View {
        VStack(spacing: 0) {
            dragHandle
            headerBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    labeledField(title: "NAME") {
                        nameField
                    }
                    labeledField(title: "TARGET AMOUNT") {
                        targetField
                    }
                    labeledField(title: "DEADLINE") {
                        deadlineField
                    }
                    labeledField(title: "ICON") {
                        iconField
                    }
                    footerButtons
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
            Text("Add New Goal")
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
        .padding(.top, 16)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, minHeight: 70.47656, maxHeight: 70.47656, alignment: .center)
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

    private var nameField: some View {
        TextField("", text: $nameText, prompt: Text("Goal Name").foregroundColor(Color.formPlaceholder))
            .font(.inter(size: 17))
            .foregroundColor(.black)
            .focused($focusedField, equals: .name)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
            .background(Color.formFieldFill)
            .cornerRadius(10)
    }

    private var targetField: some View {
        TextField("", text: $targetText, prompt: Text("0.00").foregroundColor(Color.formPlaceholder))
            .font(.inter(size: 17))
            .foregroundColor(.black)
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .target)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
            .background(Color.formFieldFill)
            .cornerRadius(10)
    }

    private var deadlineField: some View {
        HStack {
            DatePicker("", selection: $deadline, displayedComponents: .date)
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

    private var iconField: some View {
        TextField("", text: $iconText, prompt: Text("🎯").foregroundColor(Color.formPlaceholder))
            .font(.inter(size: 22))
            .foregroundColor(.black)
            .focused($focusedField, equals: .icon)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 49.47656, maxHeight: 49.47656, alignment: .leading)
            .background(Color.formFieldFill)
            .cornerRadius(10)
    }

    private var footerButtons: some View {
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
          //  .buttonStyle(.plain)
            .disabled(!canSubmit)
          // .opacity(canSubmit ? 1 : 0.45)
        }
        .padding(.top, 8)
    }

    private func submit() {
        guard let t = parsedTarget, t > 0 else { return }
        let icon = iconText.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = nameText.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.addGoal(
            icon: icon.isEmpty ? "🎯" : String(icon.prefix(4)),
            title: name,
            targetAmount: t,
            deadline: deadline
        )
        dismiss()
    }
}

#Preview {
    NewGoalSheet(viewModel: GoalsViewModel(store: AppDataStore.preview))
}
