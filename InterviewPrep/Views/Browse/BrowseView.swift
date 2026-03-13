import SwiftUI

struct BrowseView: View {
    @StateObject private var vm = BrowseViewModel()
    @State private var showingFilter = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.filteredCards.isEmpty {
                    emptyState
                } else {
                    cardList
                }
            }
            .navigationTitle("Browse")
            .searchable(text: $vm.searchText, prompt: "Search questions…")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            .sheet(isPresented: $showingFilter) {
                FilterSheetView(filter: $vm.filter)
            }
        }
    }

    // MARK: - Card List

    private var cardList: some View {
        List {
            ForEach(vm.cardsByCategory, id: \.0) { category, cards in
                Section {
                    ForEach(cards) { card in
                        NavigationLink {
                            CardDetailView(card: card)
                        } label: {
                            CardRowView(card: card)
                        }
                    }
                } header: {
                    Label(category.rawValue, systemImage: category.systemImage)
                        .font(.subheadline.weight(.semibold))
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Filter Button

    private var filterButton: some View {
        Button {
            showingFilter = true
        } label: {
            Image(systemName: vm.filter.isDefault ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                .symbolRenderingMode(.hierarchical)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView(
            "No Cards Found",
            systemImage: "doc.text.magnifyingglass",
            description: Text("Try adjusting your search or filters.")
        )
    }
}

// MARK: - Card Row

struct CardRowView: View {
    let card: AnyCard

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let lc = card.asLeetCode {
                Text("#\(lc.problemNumber) · \(lc.title)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            Text(card.question)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack(spacing: 8) {
                difficultyBadge
                if let lc = card.asLeetCode, !lc.companies.isEmpty {
                    companyBadges(lc.companies)
                }
            }
        }
        .padding(.vertical, 2)
    }

    private var difficultyBadge: some View {
        Text(card.difficulty.rawValue)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(difficultyColor.opacity(0.15), in: Capsule())
            .foregroundStyle(difficultyColor)
    }

    private func companyBadges(_ companies: Set<Company>) -> some View {
        HStack(spacing: 4) {
            ForEach(Array(companies).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { company in
                Text(company.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Color(.tertiarySystemFill), in: Capsule())
            }
        }
    }

    private var difficultyColor: Color {
        switch card.difficulty {
        case .easy:   return .green
        case .medium: return .orange
        case .hard:   return .red
        }
    }
}

// MARK: - Filter Sheet

struct FilterSheetView: View {
    @Binding var filter: CardFilter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    ForEach(CardCategory.allCases, id: \.self) { cat in
                        Toggle(cat.rawValue, isOn: Binding(
                            get: { filter.categories.contains(cat) },
                            set: { on in
                                if on { filter.categories.insert(cat) }
                                else { filter.categories.remove(cat) }
                            }
                        ))
                    }
                }

                Section("Difficulty") {
                    ForEach(Difficulty.allCases, id: \.self) { diff in
                        Toggle(diff.rawValue, isOn: Binding(
                            get: { filter.difficulties.contains(diff) },
                            set: { on in
                                if on { filter.difficulties.insert(diff) }
                                else { filter.difficulties.remove(diff) }
                            }
                        ))
                    }
                }

                Section("Companies (LeetCode)") {
                    ForEach(Company.allCases, id: \.self) { company in
                        Toggle(company.rawValue, isOn: Binding(
                            get: { filter.companies.contains(company) },
                            set: { on in
                                if on { filter.companies.insert(company) }
                                else { filter.companies.remove(company) }
                            }
                        ))
                    }
                }

                Section {
                    Button("Reset All Filters", role: .destructive) {
                        filter = CardFilter()
                    }
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
