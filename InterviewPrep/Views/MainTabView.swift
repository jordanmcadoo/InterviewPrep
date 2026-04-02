import SwiftUI

struct MainTabView: View {
    @StateObject private var store: StudyStore
    @StateObject private var mastery: CardMasteryStore
    @StateObject private var hideStore: CardHideStore
    @StateObject private var notesStore: CardNotesStore
    @StateObject private var studyVM: StudyViewModel

    init() {
        let store = StudyStore()
        let mastery = CardMasteryStore()
        let hideStore = CardHideStore()
        let notesStore = CardNotesStore()
        _store = StateObject(wrappedValue: store)
        _mastery = StateObject(wrappedValue: mastery)
        _hideStore = StateObject(wrappedValue: hideStore)
        _notesStore = StateObject(wrappedValue: notesStore)
        _studyVM = StateObject(wrappedValue: StudyViewModel(store: store, mastery: mastery))
    }

    var body: some View {
        TabView {
            NavigationStack {
                StudyView(vm: studyVM)
            }
            .environmentObject(mastery)
            .environmentObject(hideStore)
            .environmentObject(notesStore)
            .tabItem { Label("Study", systemImage: "rectangle.on.rectangle") }

            BrowseView()
                .environmentObject(mastery)
                .environmentObject(notesStore)
                .tabItem { Label("Browse", systemImage: "list.bullet.rectangle") }

            ProgressTabView()
                .environmentObject(store)
                .tabItem { Label("Progress", systemImage: "chart.bar") }
        }
    }
}
