import SwiftUI

struct DeckPickerView: View {
    @ObservedObject var vm: StudyViewModel
    @EnvironmentObject var mastery: CardMasteryStore
    @EnvironmentObject var hideStore: CardHideStore
    @State private var pendingDeck: Deck? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                sectionHeader("Quick Start")
                ForEach(DeckCatalog.all) { deck in
                    DeckCard(deck: deck, masteredCount: masteredCount(in: deck)) {
                        pendingDeck = deck
                    }
                }

                sectionHeader("By Difficulty")
                ForEach(DeckCatalog.difficultyDecks) { deck in
                    DeckCard(deck: deck, masteredCount: masteredCount(in: deck)) {
                        pendingDeck = deck
                    }
                }

                sectionHeader("By Company (LeetCode)")
                ForEach(DeckCatalog.companyDecks) { deck in
                    DeckCard(deck: deck, masteredCount: masteredCount(in: deck)) {
                        pendingDeck = deck
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .navigationTitle("Choose a Deck")
        .sheet(item: $pendingDeck) { deck in
            SessionSetupSheet(deck: deck) { startDeck in
                pendingDeck = nil
                vm.start(deck: startDeck)
            }
            .environmentObject(mastery)
            .environmentObject(hideStore)
            .presentationDetents([.height(380), .medium])
        }
    }

    private func masteredCount(in deck: Deck) -> Int {
        deck.cards.filter { mastery.isMastered($0.id) }.count
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

// MARK: - Session Setup Sheet

private struct SessionSetupSheet: View {
    let deck: Deck
    let onStart: (Deck) -> Void

    @EnvironmentObject var mastery: CardMasteryStore
    @EnvironmentObject var hideStore: CardHideStore
    @State private var masteryFilter: MasteryFilter = .notMastered
    @State private var cardCount: Int = .max
    @State private var showingHiddenCards = false

    enum MasteryFilter: String, CaseIterable {
        case all        = "All"
        case notMastered = "Review"
        case mastered   = "Done"
    }

    /// Cards in this deck that are not hidden.
    private var visibleCards: [AnyCard] {
        deck.cards.filter { !hideStore.isHidden($0.id) }
    }

    /// Hidden cards that belong to this deck (for the management sheet).
    private var hiddenDeckCards: [AnyCard] {
        deck.cards.filter { hideStore.isHidden($0.id) }
    }

    private var filteredCards: [AnyCard] {
        switch masteryFilter {
        case .all:         return visibleCards
        case .notMastered: return visibleCards.filter { !mastery.isMastered($0.id) }
        case .mastered:    return visibleCards.filter {  mastery.isMastered($0.id) }
        }
    }

    private var effectiveCount: Int { min(cardCount, max(1, filteredCards.count)) }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 4) {
                Text(deck.title).font(.title3.bold())
                Text(deck.subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            .padding(.top, 24)

            // Mastery filter
            VStack(alignment: .leading, spacing: 8) {
                Picker("", selection: $masteryFilter) {
                    ForEach(MasteryFilter.allCases, id: \.self) { f in
                        Text(f.rawValue).tag(f)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: masteryFilter) {
                    cardCount = min(cardCount, max(1, filteredCards.count))
                }

                Text(filteredCards.isEmpty ? "No cards in this filter" : "\(filteredCards.count) cards available")
                    .font(.caption)
                    .foregroundStyle(filteredCards.isEmpty ? .red : .secondary)
            }
            .padding(.horizontal, 24)

            // Count slider
            if !filteredCards.isEmpty {
                VStack(spacing: 8) {
                    HStack {
                        Text("Cards per session")
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Text("\(effectiveCount)")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }

                    Slider(
                        value: Binding(
                            get: { Double(effectiveCount) },
                            set: { cardCount = Int($0) }
                        ),
                        in: 1...Double(filteredCards.count),
                        step: 1
                    )

                    HStack {
                        Text("1")
                        Spacer()
                        Button("All (\(filteredCards.count))") { cardCount = filteredCards.count }
                            .font(.caption)
                        Spacer()
                        Text("\(filteredCards.count)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24)
            }

            // Hidden cards row
            if !hiddenDeckCards.isEmpty {
                Button {
                    showingHiddenCards = true
                } label: {
                    HStack {
                        Image(systemName: "eye.slash")
                            .foregroundStyle(.secondary)
                        Text("\(hiddenDeckCards.count) hidden card\(hiddenDeckCards.count == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("Manage")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                    .padding(.horizontal, 24)
                }
                .buttonStyle(.plain)
            }

            // Start button
            Button {
                let cards = Array(filteredCards.prefix(effectiveCount))
                let startDeck = Deck(id: deck.id, title: deck.title, subtitle: deck.subtitle,
                                     category: deck.category, cards: cards)
                onStart(startDeck)
            } label: {
                Text(filteredCards.isEmpty
                     ? "No cards available"
                     : "Start \(effectiveCount) Card\(effectiveCount == 1 ? "" : "s")")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(filteredCards.isEmpty)
            .padding(.horizontal, 24)

            Spacer()
        }
        .sheet(isPresented: $showingHiddenCards) {
            HiddenCardsSheet(hiddenCards: hiddenDeckCards, deckTitle: deck.title)
                .environmentObject(hideStore)
        }
    }
}

// MARK: - Hidden Cards Management Sheet

private struct HiddenCardsSheet: View {
    let hiddenCards: [AnyCard]
    let deckTitle: String

    @EnvironmentObject var hideStore: CardHideStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if hiddenCards.isEmpty {
                    ContentUnavailableView(
                        "No Hidden Cards",
                        systemImage: "eye",
                        description: Text("All cards in \(deckTitle) are visible.")
                    )
                } else {
                    List(hiddenCards) { card in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(card.question)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                Text(card.difficulty.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button {
                                hideStore.unhide(id: card.id)
                            } label: {
                                Label("Restore", systemImage: "eye")
                                    .font(.caption.weight(.semibold))
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Hidden Cards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
                if !hiddenCards.isEmpty {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Restore All") {
                            hiddenCards.forEach { hideStore.unhide(id: $0.id) }
                        }
                        .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}

// MARK: - Deck Card

private struct DeckCard: View {
    let deck: Deck
    let masteredCount: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: deck.category.systemImage)
                    .font(.title2)
                    .foregroundStyle(categoryColor)
                    .frame(width: 44, height: 44)
                    .background(categoryColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 3) {
                    Text(deck.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(deck.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if masteredCount > 0 {
                    Text("\(masteredCount)/\(deck.cards.count)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.green)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
        .buttonStyle(.plain)
    }

    private var categoryColor: Color {
        switch deck.category {
        case .concept:    return .blue
        case .leetcode:   return .orange
        case .discussion: return .purple
        case .behavioral: return .green
        }
    }
}
