// The Presenter is identical in role to the bridged template: it holds the
// VIPER collaborators behind protocols and contains no UIKit/SwiftUI types.
// The ONLY change versus McFlurry: `view` is the ObservableObject state object
// rather than a UIViewController, and `router` is the SwiftUI router.
@MainActor
final class CounterPresenter: CounterViewOutput, CounterInteractorOutput {

    // MARK: - VIPER Vars

    weak var view: CounterViewInput?
    var interactor: CounterInteractorInput!
    var router: CounterRouterInput!

    // MARK: - Vars

    private var isReady = false
    private let title = "Native SwiftUI VIPER"

    // MARK: - CounterViewOutput

    func viewIsReady() {
        guard !isReady else { return }
        isReady = true
        view?.render(title: title, count: interactor.currentValue())
    }

    func didTapIncrement() {
        let value = interactor.increment()
        view?.render(title: title, count: value)
    }

    func didTapShowDetail() {
        router.showDetail(value: interactor.currentValue())
    }

    // MARK: - Life cycle

    // Replaces `onWillDeallocate { presenter.willDeinit() }`. Triggered by the
    // module holder's deinit when SwiftUI tears the view's @StateObject down.
    func willDeinit() {
        interactor.deinitialize()
    }
}
