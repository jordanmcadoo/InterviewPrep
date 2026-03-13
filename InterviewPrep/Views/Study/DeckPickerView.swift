import SwiftUI

struct DeckPickerView: View {
    @ObservedObject var vm: StudyViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                sectionHeader("Quick Start")
                ForEach(DeckCatalog.all) { deck in
                    DeckCard(deck: deck) {
                        vm.start(deck: deck)
                    }
                }

                sectionHeader("By Company (LeetCode)")
                ForEach(DeckCatalog.companyDecks) { deck in
                    DeckCard(deck: deck) {
                        vm.start(deck: deck)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .navigationTitle("Choose a Deck")
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

// MARK: - Deck Card

private struct DeckCard: View {
    let deck: Deck
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
