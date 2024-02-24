import SwiftUI

@main
struct MyApp: App {
    @State var appState: AppState = .init()
    
    init() {
        let cfURL = Bundle.main.url(forResource: "Ounen-mouhitsu", withExtension: "otf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
    }
    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .preferredColorScheme(.light)
        }
    }
}
