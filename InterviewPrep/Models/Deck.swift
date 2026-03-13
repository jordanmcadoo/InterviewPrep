import Foundation

struct Deck: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let category: CardCategory
    let cards: [AnyCard]

    init(id: UUID = UUID(), title: String, subtitle: String,
         category: CardCategory, cards: [AnyCard]) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.cards = cards
    }

    var count: Int { cards.count }
}

// MARK: - Filter Model

struct CardFilter: Equatable {
    var categories: Set<CardCategory> = Set(CardCategory.allCases)
    var difficulties: Set<Difficulty> = Set(Difficulty.allCases)
    var companies: Set<Company> = Set(Company.allCases)
    var patterns: Set<AlgorithmPattern> = []  // empty = all patterns
    var searchText: String = ""

    var isDefault: Bool {
        categories == Set(CardCategory.allCases) &&
        difficulties == Set(Difficulty.allCases) &&
        companies == Set(Company.allCases) &&
        patterns.isEmpty &&
        searchText.isEmpty
    }

    func apply(to cards: [AnyCard]) -> [AnyCard] {
        cards.filter { card in
            guard categories.contains(card.category) else { return false }
            guard difficulties.contains(card.difficulty) else { return false }

            if let lc = card.asLeetCode {
                let companyMatch = lc.companies.intersection(companies).isEmpty == false
                guard companyMatch else { return false }
                if !patterns.isEmpty {
                    let patternMatch = !Set(lc.patterns).intersection(patterns).isEmpty
                    guard patternMatch else { return false }
                }
            }

            if !searchText.isEmpty {
                let text = searchText.lowercased()
                let inQuestion = card.question.lowercased().contains(text)
                let inAnswer   = card.answer.lowercased().contains(text)
                let inTitle    = card.asLeetCode?.title.lowercased().contains(text) ?? false
                guard inQuestion || inAnswer || inTitle else { return false }
            }

            return true
        }
    }
}
