import SwiftUI

@main
struct MyApp: App {
    @State var appState: AppState = .init()
    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .preferredColorScheme(.light)
        }
    }
}
