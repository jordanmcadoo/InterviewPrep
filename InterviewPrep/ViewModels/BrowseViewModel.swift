import SwiftUI
import Combine

@MainActor
final class BrowseViewModel: ObservableObject {
    @Published var filter = CardFilter()
    @Published var searchText = ""

    private let allCards: [AnyCard] = {
        let cards: [AnyCard] =
            allConceptCards.map { .concept($0) } +
            allLeetCodeCards.map { .leetcode($0) } +
            allDiscussionCards.map { .discussion($0) } +
            allBehavioralCards.map { .behavioral($0) }
        return cards
    }()

    var filteredCards: [AnyCard] {
        var f = filter
        f.searchText = searchText
        return f.apply(to: allCards)
    }

    var totalCount: Int { allCards.count }

    func resetFilter() {
        filter = CardFilter()
        searchText = ""
    }

    // MARK: - Grouped

    var cardsByCategory: [(CardCategory, [AnyCard])] {
        let grouped = Dictionary(grouping: filteredCards, by: \.category)
        return CardCategory.allCases.compactMap { category in
            guard let cards = grouped[category], !cards.isEmpty else { return nil }
            return (category, cards)
        }
    }
}
