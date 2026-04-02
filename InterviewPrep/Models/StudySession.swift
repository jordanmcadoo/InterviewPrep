import Foundation

// MARK: - Per-card result within a session
enum CardResult {
    case correct   // swiped right / "Got it"
    case incorrect // swiped left / "Review again"
    case skipped
}

// MARK: - Session state (in-memory only for Phase 1)
final class StudySession: ObservableObject {
    let deck: Deck
    private(set) var results: [UUID: CardResult] = [:]

    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var isComplete: Bool = false

    var cards: [AnyCard] { deck.cards }
    var currentCard: AnyCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }
    var nextCard: AnyCard? {
        let next = currentIndex + 1
        guard next < cards.count else { return nil }
        return cards[next]
    }

    var correctCount: Int  { results.values.filter { $0 == .correct }.count }
    var incorrectCount: Int { results.values.filter { $0 == .incorrect }.count }
    var skippedCount: Int  { results.values.filter { $0 == .skipped }.count }
    var seenCount: Int     { results.count }
    var remainingCount: Int { cards.count - currentIndex }

    var percentComplete: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(currentIndex) / Double(cards.count)
    }

    init(deck: Deck) {
        self.deck = deck
    }

    func record(_ result: CardResult) {
        guard let card = currentCard else { return }
        results[card.id] = result
        advance()
    }

    func skip() {
        guard currentCard != nil else { return }
        record(.skipped)
    }

    private func advance() {
        currentIndex += 1
        if currentIndex >= cards.count {
            isComplete = true
        }
    }

    func restart() {
        results = [:]
        currentIndex = 0
        isComplete = false
    }

    /// Cards answered incorrectly — for a quick review pass
    var incorrectCards: [AnyCard] {
        cards.filter { results[$0.id] == .incorrect }
    }
}
