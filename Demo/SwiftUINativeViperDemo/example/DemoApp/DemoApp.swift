import SwiftUI
import SwiftUINativeViper

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            // Root module entry point — the configurator hands back `some View`.
            CounterConfigurator().build()
        }
    }
}
