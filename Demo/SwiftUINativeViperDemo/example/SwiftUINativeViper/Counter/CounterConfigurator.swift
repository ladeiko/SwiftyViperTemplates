import SwiftUI
import ViperSwiftUI

// Assembles the VIPER graph and returns `some View` instead of a UIViewController.
// The opaque return type keeps every internal type private to the module while
// still letting an app embed it.
public struct CounterConfigurator {

    public init() {}

    @MainActor
    public func build() -> some View {
        let state = CounterViewState()
        let router = CounterRouter()
        let interactor = CounterInteractor(step: 1)
        let presenter = CounterPresenter()

        presenter.view = state
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter

        // ViperModuleView anchors lifetime (-> willDeinit on teardown); the
        // generic host owns NavigationStack; the router resolves routes.
        return ViperModuleView(onTeardown: { presenter.willDeinit() }) {
            ViperNavigationHost(router: router) {
                CounterRootView(state: state, output: presenter)
                    .navigationTitle("Counter")
            }
        }
    }
}
