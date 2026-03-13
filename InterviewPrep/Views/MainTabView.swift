import SwiftUI

struct MainTabView: View {
    @StateObject private var studyVM = StudyViewModel()
    @StateObject private var store = StudyStore()

    var body: some View {
        TabView {
            NavigationStack {
                StudyView(vm: studyVM)
            }
            .tabItem { Label("Study", systemImage: "rectangle.on.rectangle") }

            BrowseView()
                .tabItem { Label("Browse", systemImage: "list.bullet.rectangle") }

            ProgressTabView()
                .environmentObject(store)
                .tabItem { Label("Progress", systemImage: "chart.bar") }
        }
    }
}
