import SwiftUI

// MARK: - Leaf View (observes state, talks to ViewOutput)

struct CounterRootView: View {

    @ObservedObject var state: CounterViewState
    let output: CounterViewOutput

    var body: some View {
        VStack(spacing: 20) {
            Text(state.title)
                .font(.headline)
            Text("\(state.count)")
                .font(.system(size: 64).monospacedDigit())
            Button("Increment") { output.didTapIncrement() }
                .buttonStyle(.borderedProminent)
            Button("Show Detail →") { output.didTapShowDetail() }
        }
        .padding()
        .onAppear { output.viewIsReady() }   // replaces viewDidLoad
    }
}
