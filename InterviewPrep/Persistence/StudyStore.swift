import Foundation
import SwiftUI

// MARK: - Data models for persisted records

struct SessionRecord: Identifiable, Codable {
    let id: UUID
    let deckTitle: String
    let category: CardCategory
    let correct: Int
    let incorrect: Int
    let total: Int
    let date: Date

    var accuracyString: String {
        guard total > 0 else { return "—" }
        let pct = Int((Double(correct) / Double(total)) * 100)
        return "\(pct)%"
    }
}

struct CategoryStats {
    let seen: Int
    let total: Int
    let correct: Int

    var accuracy: Double {
        guard seen > 0 else { return 0 }
        return Double(correct) / Double(seen)
    }
    var accuracyString: String {
        guard seen > 0 else { return "—" }
        return "\(Int(accuracy * 100))%"
    }
}

// MARK: - StudyStore

@MainActor
final class StudyStore: ObservableObject {
    @Published private(set) var recentSessions: [SessionRecord] = []

    private let storageKey = "com.interviewprep.sessions"

    init() {
        load()
    }

    // MARK: - Public API

    func record(session: StudySession) {
        let record = SessionRecord(
            id: UUID(),
            deckTitle: session.deck.title,
            category: session.deck.category,
            correct: session.correctCount,
            incorrect: session.incorrectCount,
            total: session.seenCount,
            date: Date()
        )
        recentSessions.insert(record, at: 0)
        // Keep last 50 sessions
        if recentSessions.count > 50 { recentSessions = Array(recentSessions.prefix(50)) }
        save()
    }

    // MARK: - Stats

    var totalSessions: Int { recentSessions.count }

    var totalCardsSeen: Int { recentSessions.reduce(0) { $0 + $1.total } }

    var overallAccuracyString: String {
        let total = recentSessions.reduce(0) { $0 + $1.total }
        let correct = recentSessions.reduce(0) { $0 + $1.correct }
        guard total > 0 else { return "—" }
        return "\(Int(Double(correct) / Double(total) * 100))%"
    }

    func stats(for category: CardCategory) -> CategoryStats {
        let categoryTotals: [CardCategory: Int] = [
            .concept:    allConceptCards.count,
            .leetcode:   allLeetCodeCards.count,
            .discussion: allDiscussionCards.count,
            .behavioral: allBehavioralCards.count,
        ]
        let matching = recentSessions.filter { $0.category == category }
        let seen = matching.reduce(0) { $0 + $1.total }
        let correct = matching.reduce(0) { $0 + $1.correct }
        return CategoryStats(
            seen: min(seen, categoryTotals[category] ?? 0),
            total: categoryTotals[category] ?? 0,
            correct: correct
        )
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(recentSessions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let records = try? JSONDecoder().decode([SessionRecord].self, from: data) else { return }
        recentSessions = records
    }
}
