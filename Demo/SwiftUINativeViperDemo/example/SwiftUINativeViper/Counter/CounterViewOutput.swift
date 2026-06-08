// V -> P. The SwiftUI View calls these directly (no RootViewDelegate hop).
@MainActor
protocol CounterViewOutput: AnyObject {
    func viewIsReady()
    func didTapIncrement()
    func didTapShowDetail()
}
