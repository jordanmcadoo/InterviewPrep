import SwiftUI

// Drives rotation AND visibility from a single animatable value so the
// face swap happens exactly when the card is edge-on (progress == 0.5),
// not at the start/end of the animation.
private struct CardFaceModifier: AnimatableModifier {
    var progress: Double  // 0 = front showing, 1 = back showing
    let isFront: Bool

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        // Front: 0° → 180°   Back: -90° → 0°  (both edge-on at progress == 0.5)
        let angle = isFront ? progress * 180 : (progress - 1) * 180
        let visible = isFront ? progress < 0.5 : progress >= 0.5
        content
            .rotation3DEffect(.degrees(angle), axis: (0, 1, 0), perspective: 0.3)
            .opacity(visible ? 1 : 0)
    }
}

struct FlashCardView: View {
    let card: AnyCard
    @Binding var isFlipped: Bool
    @EnvironmentObject private var notesStore: CardNotesStore

    var body: some View {
        ZStack {
            frontSide
                .modifier(CardFaceModifier(progress: isFlipped ? 1 : 0, isFront: true))
            backSide
                .modifier(CardFaceModifier(progress: isFlipped ? 1 : 0, isFront: false))
        }
        .animation(.spring(duration: 0.5), value: isFlipped)
        .onTapGesture { isFlipped.toggle() }
    }

    // MARK: - Front

    private var frontSide: some View {
        cardContainer {
            VStack(spacing: 16) {
                categoryBadge
                Spacer()
                Text(card.question)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if let lc = card.asLeetCode {
                    leetCodeMeta(lc)
                }
                hintLabel
            }
        }
    }

    // MARK: - Back

    private var backSide: some View {
        cardContainer {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    categoryBadge
                    Spacer()
                    difficultyBadge
                }
                Divider()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(card.answer)
                            .font(.callout)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if card.category == .behavioral,
                           notesStore.hasNote(for: card.id) {
                            notesPreview
                        }
                    }
                }
            }
        }
    }

    private var notesPreview: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("My Notes", systemImage: "note.text")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(notesStore.note(for: card.id))
                .font(.caption)
                .lineSpacing(3)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(.tertiarySystemFill), in: RoundedRectangle(cornerRadius: 8))
        }
    }

    // MARK: - Helpers

    private func cardContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
            )
    }

    private var categoryBadge: some View {
        Label(card.category.rawValue, systemImage: card.category.systemImage)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(categoryColor.opacity(0.15), in: Capsule())
            .foregroundStyle(categoryColor)
    }

    private var difficultyBadge: some View {
        Text(card.difficulty.rawValue)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(difficultyColor.opacity(0.15), in: Capsule())
            .foregroundStyle(difficultyColor)
    }

    private var hintLabel: some View {
        Text("Tap to reveal answer")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private func leetCodeMeta(_ lc: LeetCodeCard) -> some View {
        VStack(spacing: 6) {
            Text("#\(lc.problemNumber) · \(lc.title)")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(lc.patterns, id: \.self) { pattern in
                        Text(pattern.rawValue)
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.blue.opacity(0.1), in: Capsule())
                            .foregroundStyle(Color.blue)
                    }
                }
            }
        }
    }

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
