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

// MARK: - CardMasteryStore

/// Persists the set of card IDs the user has marked "Got It" across all sessions.
@MainActor
final class CardMasteryStore: ObservableObject {
    @Published private(set) var masteredIDs: Set<UUID> = []

    private let key = "com.interviewprep.mastered"

    init() { load() }

    func master(id: UUID) {
        masteredIDs.insert(id)
        save()
    }

    func unmaster(id: UUID) {
        masteredIDs.remove(id)
        save()
    }

    func isMastered(_ id: UUID) -> Bool {
        masteredIDs.contains(id)
    }

    private func save() {
        UserDefaults.standard.set(masteredIDs.map { $0.uuidString }, forKey: key)
    }

    private func load() {
        let strings = UserDefaults.standard.stringArray(forKey: key) ?? []
        masteredIDs = Set(strings.compactMap(UUID.init))
    }
}

// MARK: - CardNotesStore

/// Persists user-written notes keyed by card ID. Designed for behavioral cards
/// but the store is card-agnostic — the views decide when to surface it.
@MainActor
final class CardNotesStore: ObservableObject {
    @Published private(set) var notes: [UUID: String] = [:]

    private let key = "com.interviewprep.notes"

    init() { load() }

    func note(for id: UUID) -> String {
        notes[id] ?? ""
    }

    func setNote(_ text: String, for id: UUID) {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notes.removeValue(forKey: id)
        } else {
            notes[id] = text
        }
        save()
    }

    func hasNote(for id: UUID) -> Bool {
        guard let note = notes[id] else { return false }
        return !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func save() {
        let dict = Dictionary(uniqueKeysWithValues: notes.map { ($0.key.uuidString, $0.value) })
        UserDefaults.standard.set(dict, forKey: key)
    }

    private func load() {
        guard let dict = UserDefaults.standard.dictionary(forKey: key) as? [String: String] else { return }
        notes = Dictionary(uniqueKeysWithValues: dict.compactMap { k, v in
            UUID(uuidString: k).map { ($0, v) }
        })
    }
}

// MARK: - CardHideStore

/// Persists the set of card IDs the user has hidden from their decks.
/// Hidden cards are excluded from study sessions but can be restored at any time.
@MainActor
final class CardHideStore: ObservableObject {
    @Published private(set) var hiddenIDs: Set<UUID> = []

    private let key = "com.interviewprep.hidden"

    init() { load() }

    func hide(id: UUID) {
        hiddenIDs.insert(id)
        save()
    }

    func unhide(id: UUID) {
        hiddenIDs.remove(id)
        save()
    }

    func isHidden(_ id: UUID) -> Bool {
        hiddenIDs.contains(id)
    }

    private func save() {
        UserDefaults.standard.set(hiddenIDs.map { $0.uuidString }, forKey: key)
    }

    private func load() {
        let strings = UserDefaults.standard.stringArray(forKey: key) ?? []
        hiddenIDs = Set(strings.compactMap(UUID.init))
    }
}
