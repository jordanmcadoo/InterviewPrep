import Foundation

// MARK: - Deck Builder Helpers

extension Deck {
    static func makeMixed() -> Deck {
        let cards: [AnyCard] =
            allConceptCards.map { .concept($0) } +
            allLeetCodeCards.map { .leetcode($0) } +
            allDiscussionCards.map { .discussion($0) } +
            allBehavioralCards.map { .behavioral($0) }
        return Deck(
            title: "Full Mix",
            subtitle: "\(cards.count) cards across all categories",
            category: .concept,   // doesn't matter for mixed deck
            cards: cards.shuffled()
        )
    }

    static func makeConcepts() -> Deck {
        let cards = allConceptCards.map { AnyCard.concept($0) }
        return Deck(
            title: "Swift & iOS Concepts",
            subtitle: "\(cards.count) cards",
            category: .concept,
            cards: cards.shuffled()
        )
    }

    static func makeLeetCode(companies: Set<Company> = []) -> Deck {
        let filtered: [LeetCodeCard] = companies.isEmpty
            ? allLeetCodeCards
            : allLeetCodeCards.filter { !$0.companies.intersection(companies).isEmpty }
        let cards = filtered.map { AnyCard.leetcode($0) }
        let subtitle = companies.isEmpty
            ? "\(cards.count) problems"
            : "\(cards.count) problems • \(companies.map(\.rawValue).sorted().joined(separator: ", "))"
        return Deck(
            title: "LeetCode",
            subtitle: subtitle,
            category: .leetcode,
            cards: cards.shuffled()
        )
    }

    static func makeDiscussion() -> Deck {
        let cards = allDiscussionCards.map { AnyCard.discussion($0) }
        return Deck(
            title: "Technical Discussion",
            subtitle: "\(cards.count) questions",
            category: .discussion,
            cards: cards.shuffled()
        )
    }

    static func makeBehavioral() -> Deck {
        let cards = allBehavioralCards.map { AnyCard.behavioral($0) }
        return Deck(
            title: "Behavioral",
            subtitle: "\(cards.count) questions",
            category: .behavioral,
            cards: cards.shuffled()
        )
    }

    static func makeByDifficulty(_ difficulty: Difficulty) -> Deck {
        let all: [AnyCard] =
            allConceptCards.map { .concept($0) } +
            allLeetCodeCards.map { .leetcode($0) } +
            allDiscussionCards.map { .discussion($0) } +
            allBehavioralCards.map { .behavioral($0) }
        let cards = all.filter { $0.difficulty == difficulty }
        return Deck(
            title: difficulty.rawValue,
            subtitle: "\(cards.count) cards",
            category: .concept,
            cards: cards.shuffled()
        )
    }
}

// MARK: - Default Deck Catalog

struct DeckCatalog {
    static let all: [Deck] = [
        .makeMixed(),
        .makeConcepts(),
        .makeLeetCode(),
        .makeDiscussion(),
        .makeBehavioral(),
        .makeByDifficulty(.easy),
        .makeByDifficulty(.medium),
        .makeByDifficulty(.hard),
    ]

    // Company-specific LeetCode decks
    static let companyDecks: [Deck] = Company.allCases.map { company in
        Deck.makeLeetCode(companies: [company])
    }
}
