import SwiftUI
import ViperSwiftUI

// Navigation contract the Presenter talks to. Only the Router knows about
// other modules — same VIPER invariant as the McFlurry version, but instead
// of imperatively driving a ViperModuleTransitionHandler it mutates published
// navigation state that a SwiftUI NavigationStack is bound to.
@MainActor
protocol CounterRouterInput: AnyObject {
    func showDetail(value: Int)
}

enum CounterRoute: Hashable {
    case detail(value: Int)
}

final class CounterRouter: ObservableObject, CounterRouterInput, NavigationRouting {

    @Published var path: [CounterRoute] = []

    // MARK: - CounterRouterInput  (navigation intent — called by the Presenter)

    func showDetail(value: Int) {
        path.append(.detail(value: value))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    // MARK: - NavigationRouting  (route -> child module — was inside the View)

    func destination(for route: CounterRoute) -> AnyView {
        switch route {
        case let .detail(value):
            AnyView(DetailConfigurator().build(value: value))
        }
    }
}
