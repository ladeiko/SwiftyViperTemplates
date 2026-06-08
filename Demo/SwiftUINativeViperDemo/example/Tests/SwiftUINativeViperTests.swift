import XCTest
import ViperSwiftUI
@testable import SwiftUINativeViper

@MainActor
final class SwiftUINativeViperTests: XCTestCase {

    // Wires the Counter graph exactly as CounterConfigurator does, but keeps
    // references so the flow can be driven and asserted without a UI host.
    private func makeCounter(step: Int = 1) -> (CounterPresenter, CounterViewState, CounterRouter, CounterInteractor) {
        let state = CounterViewState()
        let router = CounterRouter()
        let interactor = CounterInteractor(step: step)
        let presenter = CounterPresenter()
        presenter.view = state
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        return (presenter, state, router, interactor)
    }

    // V -> P -> I -> V : onAppear renders the interactor's current value.
    func testViewIsReadyRendersInitialState() {
        let (presenter, state, _, _) = makeCounter()
        presenter.viewIsReady()
        XCTAssertEqual(state.title, "Native SwiftUI VIPER")
        XCTAssertEqual(state.count, 0)
    }

    // Button tap routes through interactor business logic back into state.
    func testIncrementFlowUsesInteractorStep() {
        let (presenter, state, _, _) = makeCounter(step: 2)
        presenter.viewIsReady()
        presenter.didTapIncrement()
        presenter.didTapIncrement()
        XCTAssertEqual(state.count, 4)
    }

    // Presenter never touches navigation directly — only the Router mutates path.
    func testShowDetailPushesRoute() {
        let (presenter, _, router, _) = makeCounter()
        presenter.viewIsReady()
        presenter.didTapIncrement()
        presenter.didTapShowDetail()
        XCTAssertEqual(router.path, [.detail(value: 1)])
    }

    // willDeinit (fired by the holder's deinit) tears the interactor down.
    func testWillDeinitResetsInteractor() {
        let (presenter, _, _, interactor) = makeCounter()
        _ = interactor.increment()
        XCTAssertEqual(interactor.currentValue(), 1)
        presenter.willDeinit()
        XCTAssertEqual(interactor.currentValue(), 0)
    }

    // The SwiftUI-native lifetime anchor: releasing the holder runs teardown.
    // This is what @StateObject does when the view leaves the hierarchy.
    // Teardown is delivered asynchronously ON the MainActor (OnDeallocateX
    // semantics), NOT synchronously in the destructor — so we await it.
    func testModuleHolderDeinitSchedulesTeardownOnMainActor() async {
        let delivered = expectation(description: "teardown delivered on main actor")
        var holder: ViperModuleHolder? = ViperModuleHolder(
            onTeardown: {
                XCTAssertTrue(Thread.isMainThread)
                delivered.fulfill()
            }
        )
        XCTAssertNotNil(holder)
        holder = nil               // ARC -> deinit -> Task { @MainActor ... }
        await fulfillment(of: [delivered], timeout: 1.0)
    }

    // The holder (`self`) is dead by the time teardown runs, but the captured
    // onTeardown closure keeps the presenter alive across the gap — willDeinit()
    // runs on a LIVE presenter — and the presenter is released right after, so
    // there is no leak. Mirrors `viewController.onWillDeallocate { ... }`.
    func testPresenterIsAliveDuringTeardownThenReleased() async {
        weak var weakPresenter: CounterPresenter?
        weak var weakInteractor: CounterInteractor?
        let tornDown = expectation(description: "teardown ran")

        var holder: ViperModuleHolder? = {
            let state = CounterViewState()
            let router = CounterRouter()
            let interactor = CounterInteractor()
            let presenter = CounterPresenter()
            presenter.view = state
            presenter.interactor = interactor
            presenter.router = router
            interactor.output = presenter
            weakPresenter = presenter
            weakInteractor = interactor
            return ViperModuleHolder(
                onTeardown: {
                    // presenter must still be alive here
                    XCTAssertNotNil(weakPresenter)
                    presenter.willDeinit()
                    tornDown.fulfill()
                }
            )
        }()

        holder = nil
        // Holder is gone, but the in-flight teardown closure keeps presenter alive.
        XCTAssertNotNil(weakPresenter, "presenter must outlive the holder until teardown")

        await fulfillment(of: [tornDown], timeout: 1.0)

        // After teardown the Task releases its captured closure -> presenter frees.
        for _ in 0..<50 where weakPresenter != nil { await Task.yield() }
        XCTAssertNil(weakPresenter, "presenter must be released after teardown (no leak)")
        XCTAssertNil(weakInteractor, "interactor must be released after teardown (no leak)")
    }

    // Child module computes its own presentation via its interactor.
    func testDetailModuleRendersDescription() {
        let state = DetailViewState()
        let presenter = DetailPresenter(value: 4)
        presenter.view = state
        presenter.interactor = DetailInteractor()
        presenter.viewIsReady()
        XCTAssertTrue(state.text.contains("even"), "got: \(state.text)")
    }
}
