import Combine

// P -> V. In the bridged template this is adopted by a UIViewController.
// Here it is adopted by a reference-typed ObservableObject view-state, which
// is the binding point a value-type SwiftUI View can observe.
@MainActor
protocol CounterViewInput: AnyObject {
    func render(title: String, count: Int)
}

final class CounterViewState: ObservableObject, CounterViewInput {

    @Published private(set) var title: String = ""
    @Published private(set) var count: Int = 0

    // MARK: - CounterViewInput

    func render(title: String, count: Int) {
        self.title = title
        self.count = count
    }
}
