import SwiftUI

struct CardDetailView: View {
    let card: AnyCard
    @EnvironmentObject var mastery: CardMasteryStore
    @EnvironmentObject var notesStore: CardNotesStore
    @State private var isAnswerVisible = false
    @State private var noteText: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                metaSection
                questionSection
                answerSection
                if let lc = card.asLeetCode {
                    leetCodeSection(lc)
                }
                if card.category == .behavioral {
                    notesSection
                }
            }
            .padding()
        }
        .navigationTitle(card.asLeetCode?.title ?? card.category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { noteText = notesStore.note(for: card.id) }
        .onChange(of: noteText) { notesStore.setNote(noteText, for: card.id) }
    }

    // MARK: - Meta

    private var metaSection: some View {
        HStack(spacing: 8) {
            Label(card.category.rawValue, systemImage: card.category.systemImage)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(categoryColor.opacity(0.12), in: Capsule())
                .foregroundStyle(categoryColor)

            Text(card.difficulty.rawValue)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(difficultyColor.opacity(0.12), in: Capsule())
                .foregroundStyle(difficultyColor)

            Spacer()

            // Mastery toggle
            Button {
                if mastery.isMastered(card.id) {
                    mastery.unmaster(id: card.id)
                } else {
                    mastery.master(id: card.id)
                }
            } label: {
                Label(
                    "Got It",
                    systemImage: mastery.isMastered(card.id) ? "checkmark.circle.fill" : "circle"
                )
                .font(.caption.weight(.semibold))
                .foregroundStyle(mastery.isMastered(card.id) ? .green : .secondary)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Question

    private var questionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Question", systemImage: "questionmark.circle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            Text(card.question)
                .font(.body)
                .lineSpacing(4)
        }
    }

    // MARK: - Answer

    private var answerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    isAnswerVisible.toggle()
                }
            } label: {
                HStack {
                    Label("Answer", systemImage: "lightbulb")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Spacer()
                    Image(systemName: isAnswerVisible ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            if isAnswerVisible {
                Text(card.answer)
                    .font(.callout)
                    .lineSpacing(5)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                    .transition(.opacity)
            }
        }
    }

    // MARK: - Notes Section

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("My Notes", systemImage: "note.text")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $noteText)
                    .font(.callout)
                    .lineSpacing(4)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                    .scrollContentBackground(.hidden)

                if noteText.isEmpty {
                    Text("Write your STAR story, key talking points, or examples here…")
                        .font(.callout)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    // MARK: - LeetCode Section

    private func leetCodeSection(_ lc: LeetCodeCard) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()

            infoRow(label: "Complexity", icon: "clock") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Time: \(lc.timeComplexity)")
                    Text("Space: \(lc.spaceComplexity)")
                }
                .font(.callout)
            }

            infoRow(label: "Patterns", icon: "tag") {
                FlowLayout(spacing: 6) {
                    ForEach(lc.patterns, id: \.self) { pattern in
                        Text(pattern.rawValue)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.blue.opacity(0.1), in: Capsule())
                            .foregroundStyle(Color.blue)
                    }
                }
            }

            infoRow(label: "Companies", icon: "building.2") {
                FlowLayout(spacing: 6) {
                    ForEach(Array(lc.companies).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { company in
                        Text(company.rawValue)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.purple.opacity(0.1), in: Capsule())
                            .foregroundStyle(Color.purple)
                    }
                }
            }
        }
    }

    private func infoRow<Content: View>(label: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            content()
        }
    }

    // MARK: - Colors

    private var categoryColor: Color {
        switch card.category {
        case .concept:    return .blue
        case .leetcode:   return .orange
        case .discussion: return .purple
        case .behavioral: return .green
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

// MARK: - Flow Layout (tag wrapping)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var height: CGFloat = 0
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if rowWidth + size.width > maxWidth, rowWidth > 0 {
                height += rowHeight + spacing
                rowWidth = 0
                rowHeight = 0
            }
            rowWidth += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
