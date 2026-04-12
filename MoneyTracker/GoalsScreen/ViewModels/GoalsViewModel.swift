//
//  GoalsViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
final class GoalsViewModel: ObservableObject {
    private let store: AppDataStore
    private var cancellables = Set<AnyCancellable>()

    init(store: AppDataStore) {
        self.store = store
        store.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var goals: [GoalProgressItem] { store.goals }

    private static let newGoalDeadlineFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateStyle = .medium
        return f
    }()

    func addGoal(icon: String, title: String, targetAmount: Double, deadline: Date) {
        let deadlineText = Self.newGoalDeadlineFormatter.string(from: deadline)
        let item = GoalProgressItem(
            icon: icon,
            title: title,
            deadlineText: deadlineText,
            currentAmount: 0,
            targetAmount: max(targetAmount, 0.01)
        )
        var next = store.goals
        next.insert(item, at: 0)
        store.setGoals(next)
    }

    /// Adds `amount` toward the goal (capped at target). Persists via `AppDataStore`.
    func addContribution(to id: UUID, amount: Double) {
        guard amount > 0 else { return }
        var next = store.goals
        guard let i = next.firstIndex(where: { $0.id == id }) else { return }
        let g = next[i]
        let newCurrent = min(g.currentAmount + amount, g.targetAmount)
        next[i] = GoalProgressItem(
            id: g.id,
            icon: g.icon,
            title: g.title,
            deadlineText: g.deadlineText,
            currentAmount: newCurrent,
            targetAmount: g.targetAmount
        )
        store.setGoals(next)
    }

    func addProgress(to id: UUID, delta: Double = 100) {
        addContribution(to: id, amount: delta)
    }

    func deleteGoal(id: UUID) {
        var next = store.goals
        next.removeAll { $0.id == id }
        store.setGoals(next)
    }
}
