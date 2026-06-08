// Business logic. Unchanged in spirit from the UIKit VIPER interactor.
protocol CounterInteractorInput: AnyObject {
    func currentValue() -> Int
    func increment() -> Int
    func deinitialize()
}

protocol CounterInteractorOutput: AnyObject {
    // No async callbacks needed in this demo; kept to mirror VIPER shape.
}

final class CounterInteractor: CounterInteractorInput {

    weak var output: CounterInteractorOutput?

    private var value = 0
    private let step: Int

    init(step: Int = 1) {
        self.step = step
    }

    // MARK: - CounterInteractorInput

    func currentValue() -> Int { value }

    func increment() -> Int {
        value += step
        return value
    }

    func deinitialize() {
        value = 0
    }
}
