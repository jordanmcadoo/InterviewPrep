import SwiftUI

@MainActor
final class StudyViewModel: ObservableObject {
    @Published private(set) var session: StudySession?
    @Published var showingDeckPicker = true

    func start(deck: Deck) {
        session = StudySession(deck: deck.withShuffledCards())
        showingDeckPicker = false
    }

    func answer(_ result: CardResult) {
        session?.record(result)
    }

    func skip() {
        session?.skip()
    }

    func restartSession() {
        session?.restart()
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
