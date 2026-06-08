import SwiftUI
import Combine
import ViperSwiftUI

// A second module to prove cross-module navigation + independent teardown.
// Same VIPER layering as Counter, condensed into one file for the demo.

// MARK: - View contracts

@MainActor
protocol DetailViewInput: AnyObject {
    func render(text: String)
}

@MainActor
protocol DetailViewOutput: AnyObject {
    func viewIsReady()
}

final class DetailViewState: ObservableObject, DetailViewInput {
    @Published private(set) var text: String = ""
    func render(text: String) { self.text = text }
}

// MARK: - Interactor

protocol DetailInteractorInput: AnyObject {
    func describe(value: Int) -> String
    func deinitialize()
}

final class DetailInteractor: DetailInteractorInput {
    func describe(value: Int) -> String {
        "Navigated with value \(value).\nIt is \(value % 2 == 0 ? "even" : "odd")."
    }
    func deinitialize() {}
}

// MARK: - Presenter

@MainActor
final class DetailPresenter: DetailViewOutput {

    weak var view: DetailViewInput?
    var interactor: DetailInteractorInput!

    private let value: Int

    init(value: Int) { self.value = value }

    func viewIsReady() {
        view?.render(text: interactor.describe(value: value))
    }

    func willDeinit() {
        interactor.deinitialize()
    }
}

// MARK: - View + lifetime anchor

struct DetailRootView: View {
    @ObservedObject var state: DetailViewState
    let output: DetailViewOutput

    var body: some View {
        VStack(spacing: 16) {
            Text(state.text)
                .multilineTextAlignment(.center)
                .font(.title3)
        }
        .padding()
        .navigationTitle("Detail")
        .onAppear { output.viewIsReady() }
    }
}

// MARK: - Configurator (internal; created by CounterRouter)

struct DetailConfigurator {
    @MainActor
    func build(value: Int) -> some View {
        let state = DetailViewState()
        let interactor = DetailInteractor()
        let presenter = DetailPresenter(value: value)

        presenter.view = state
        presenter.interactor = interactor

        return ViperModuleView(onTeardown: { presenter.willDeinit() }) {
            DetailRootView(state: state, output: presenter)
        }
    }
}
