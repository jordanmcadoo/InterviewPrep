import SwiftUI

// MARK: - Top-level router

struct StudyView: View {
    @ObservedObject var vm: StudyViewModel
    @EnvironmentObject private var hideStore: CardHideStore

    var body: some View {
        Group {
            if vm.showingDeckPicker {
                DeckPickerView(vm: vm)
            } else if let session = vm.session {
                // ActiveStudyView observes session directly and handles its
                // own completion routing, since StudyView only observes vm.
                ActiveStudyView(session: session, vm: vm)
            }
        }
        .navigationTitle("Study")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.hideStore = hideStore }
    }
}

// MARK: - Active study (observes session directly)

private struct ActiveStudyView: View {
    @ObservedObject var session: StudySession
    @ObservedObject var vm: StudyViewModel

    @State private var isFlipped = false
    @State private var dragOffset: CGFloat = 0
    @State private var showingHideConfirmation = false

    var body: some View {
        if session.isComplete {
            CompletionView(session: session, vm: vm)
        } else {
            cardUI
        }
    }

    @ViewBuilder
    private var cardUI: some View {
        VStack(spacing: 0) {
            progressBar
            Spacer(minLength: 12)

            ZStack {
                // n+1: full opacity, blocked by current card on top
                if let next = session.nextCard {
                    FlashCardView(card: next, isFlipped: .constant(false))
                        .padding(.horizontal, 20)
                        .frame(maxHeight: 460)
                        .allowsHitTesting(false)
                }

                // Current card on top
                if let card = session.currentCard {
                    FlashCardView(card: card, isFlipped: $isFlipped)
                        .overlay(stampOverlay)
                        .overlay(alignment: .topLeading) { hideButton }
                        .padding(.horizontal, 20)
                        .frame(maxHeight: 460)
                        .offset(x: dragOffset)
                        .rotationEffect(.degrees(Double(dragOffset / 20)))
                        .gesture(swipeGesture)
                }
            }

            Spacer(minLength: 16)
            actionButtons
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
        }
        .onChange(of: session.currentIndex) {
            var t = Transaction(animation: nil)
            t.disablesAnimations = true
            withTransaction(t) {
                isFlipped = false
                dragOffset = 0
            }
        }
    }

    // MARK: - Stamp overlay

    private var stampOverlay: some View {
        ZStack {
            if dragOffset > 20 {
                Text("GOT IT")
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.green, lineWidth: 5))
                    .rotationEffect(.degrees(-20))
                    .opacity(Double(min(dragOffset / 80, 1.0)))
            } else if dragOffset < -20 {
                Text("MISSED")
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.red, lineWidth: 5))
                    .rotationEffect(.degrees(20))
                    .opacity(Double(min(-dragOffset / 80, 1.0)))
            }
        }
    }

    // MARK: - Progress bar

    private var progressBar: some View {
        VStack(spacing: 6) {
            HStack {
                Button("Exit", action: vm.backToDeckPicker)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(min(session.currentIndex + 1, session.cards.count)) / \(session.cards.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)

            ProgressView(value: session.percentComplete)
                .tint(.blue)
                .padding(.horizontal, 20)
        }
        .padding(.top, 12)
    }

    // MARK: - Buttons

    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button { answer(.incorrect) } label: {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.red, in: Circle())
                    .shadow(color: .red.opacity(0.3), radius: 8, y: 4)
            }

            Button {
                isFlipped.toggle()
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .frame(width: 48, height: 48)
                    .background(Color.blue.opacity(0.12), in: Circle())
            }

            Button { answer(.correct) } label: {
                Image(systemName: "checkmark")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.green, in: Circle())
                    .shadow(color: .green.opacity(0.3), radius: 8, y: 4)
            }
        }
    }

    // MARK: - Hide button

    private var hideButton: some View {
        Button {
            showingHideConfirmation = true
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color(.systemGray3))
                .font(.title3)
        }
        .buttonStyle(.plain)
        .padding(16)
//        .padding(.top, 8)
//        .padding(.leading, 8)
//        .padding(.trailing, 16)
//        .padding(.bottom, 16)
        .alert("Remove This Card?", isPresented: $showingHideConfirmation) {
            Button("Remove", role: .destructive) { vm.hideCurrentCard() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This card will be removed from the deck. You can add it back later from the deck settings.")
        }
    }

    // MARK: - Swipe gesture

    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                if value.translation.width > threshold {
                    flyOut(direction: 1, result: .correct)
                } else if value.translation.width < -threshold {
                    flyOut(direction: -1, result: .incorrect)
                } else {
                    withAnimation(.spring()) { dragOffset = 0 }
                }
            }
    }

    private func flyOut(direction: CGFloat, result: CardResult) {
        withAnimation(.spring(duration: 0.3), completionCriteria: .logicallyComplete) {
            dragOffset = direction * 500
        } completion: {
            vm.answer(result)
        }
    }

    private func answer(_ result: CardResult) {
        vm.answer(result)
    }
}

// MARK: - Completion screen

private struct CompletionView: View {
    @ObservedObject var session: StudySession
    @ObservedObject var vm: StudyViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 24)

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)

                VStack(spacing: 8) {
                    Text("Session Complete!")
                        .font(.title.bold())
                    Text(session.deck.title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 0) {
                    statCell(value: session.correctCount,   label: "Got It",  color: .green,  icon: "checkmark.circle.fill")
                    Divider().frame(height: 50)
                    statCell(value: session.incorrectCount, label: "Missed",  color: .red,    icon: "xmark.circle.fill")
                    Divider().frame(height: 50)
                    statCell(value: session.skippedCount,   label: "Skipped", color: .orange, icon: "arrow.right.circle.fill")
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                VStack(spacing: 12) {
                    if session.incorrectCount > 0 {
                        Button {
                            vm.startReviewingWrong()
                        } label: {
                            Label("Review \(session.incorrectCount) Missed Cards", systemImage: "arrow.counterclockwise")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.red)
                    }

                    Button {
                        vm.restartSession()
                    } label: {
                        Label("Restart Deck", systemImage: "shuffle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Button("Back to Decks", action: vm.backToDeckPicker)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 32)
            }
        }
    }

    private func statCell(value: Int, label: String, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.title2).foregroundStyle(color)
            Text("\(value)").font(.title2.bold())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview("Active Session") {
    let mastery = CardMasteryStore()
    let vm = StudyViewModel(store: StudyStore(), mastery: mastery)
    vm.start(deck: DeckCatalog.all.first!)
    return NavigationStack {
        StudyView(vm: vm)
    }
    .environmentObject(mastery)
    .environmentObject(CardHideStore())
    .environmentObject(CardNotesStore())
}
