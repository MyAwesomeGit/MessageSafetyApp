import SwiftUI

@main
struct MessageSafetyApp: App {
    @StateObject private var logger = MessageLogger()
    
    var body: some Scene {
        WindowGroup {
            MessageSafetyView()
                .environmentObject(logger)
        }
    }
}
