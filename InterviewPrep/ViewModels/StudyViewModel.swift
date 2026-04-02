import SwiftUI

@MainActor
final class StudyViewModel: ObservableObject {
    @Published private(set) var session: StudySession?
    @Published var showingDeckPicker = true

    private let store: StudyStore
    private let mastery: CardMasteryStore
    var hideStore: CardHideStore?

    init(store: StudyStore, mastery: CardMasteryStore) {
        self.store = store
        self.mastery = mastery
    }

    func start(deck: Deck) {
        session = StudySession(deck: deck.withShuffledCards())
        showingDeckPicker = false
    }

    func answer(_ result: CardResult) {
        guard let session else { return }
        // Update mastery before advancing the index
        if let card = session.currentCard {
            if result == .correct   { mastery.master(id: card.id) }
            if result == .incorrect { mastery.unmaster(id: card.id) }
        }
        session.record(result)
        if session.isComplete {
            store.record(session: session)
        }
    }

    func skip() {
        session?.skip()
    }

    func restartSession() {
        session?.restart()
    }

    func hideCurrentCard() {
        guard let card = session?.currentCard else { return }
        hideStore?.hide(id: card.id)
        session?.skip()
    }

    func backToDeckPicker() {
        session = nil
        showingDeckPicker = true
    }

    func startReviewingWrong() {
        guard let session else { return }
        let wrongCards = session.incorrectCards
        guard !wrongCards.isEmpty else { return }
        let reviewDeck = Deck(
            title: "Review: \(session.deck.title)",
            subtitle: "\(wrongCards.count) missed cards",
            category: session.deck.category,
            cards: wrongCards
        )
        self.session = StudySession(deck: reviewDeck)
    }
}

private extension Deck {
    func withShuffledCards() -> Deck {
        Deck(id: id, title: title, subtitle: subtitle, category: category, cards: cards.shuffled())
    }
}
