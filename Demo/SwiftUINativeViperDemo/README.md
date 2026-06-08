# SwiftUI-native VIPER — runnable demo

A small, self-contained proof of the **VIPER-inside-SwiftUI** pattern: SwiftUI owns
view lifetime and navigation, with **no dependency on ViperMcFlurryX / UIKit**.
Contrast with `Demo/Templates/default_swiftui`, which *bridges* SwiftUI inside a
`UIViewController` + `UIHostingController` and keeps VIPER UIKit-centric.

## Run / test

```bash
swift test          # builds the library + app, runs the VIPER flow tests
swift run DemoApp    # launches the SwiftUI app (opens a window on macOS)
```

The same `Sources/SwiftUINativeViper` library compiles for iOS 16+; drop
`CounterConfigurator().build()` into any `WindowGroup`/`NavigationStack` host.

## What it demonstrates

Two cooperating modules: a `Counter` root that navigates to a `Detail` child.

| VIPER role | Native-SwiftUI form in this demo |
|---|---|
| **ViewInput** (P→V) | `CounterViewState : ObservableObject` — the reference-typed binding point a value-type `View` can observe |
| **ViewOutput** (V→P) | `CounterRootView` calls the presenter directly from `.onAppear` / button actions |
| **Presenter / Interactor** | plain classes, **identical in role** to the UIKit templates — zero SwiftUI imports |
| **Router** | `CounterRouter : ObservableObject` with `@Published path`; `NavigationStack(path:)` is bound to it |
| **Lifetime** | `CounterModuleHolder` held as `@StateObject`; its `deinit` calls `presenter.willDeinit()` — the replacement for `onWillDeallocate` |
| **Configurator** | returns `some View` instead of a `UIViewController` |

## Layout

```
example/SwiftUINativeViper/  per-module VIPER code (depends on ViperSwiftUI)
  Counter/   CounterViewInput / ViewOutput / Interactor / Router / Presenter / View / Configurator
  Detail/    DetailModule.swift (same layering, condensed)
example/DemoApp/             @main SwiftUI App entry point
example/Tests/               drives the VIPER flow + asserts teardown without a UI host
```

The reusable runtime — lifetime/teardown anchor and the generic `NavigationStack`
host — comes from the **ViperSwiftUI** package, declared as a dependency in
`Package.swift`:

```swift
.package(url: "git@github.com:ladeiko/swiftui-viper.git", from: "1.0.0")
```

`ViperSwiftUI` is the SwiftUI analog of `ViperMcFlurryX`: the plumbing every
module shares. A module never re-implements lifetime, teardown, or
`NavigationStack` — it only writes its V/I/P/E/R + Configurator. (The repo is
currently private, hence the SSH URL; switch to the `https://` URL once public.)

## Tests (all green)

- `testViewIsReadyRendersInitialState` — onAppear → presenter → interactor → state
- `testIncrementFlowUsesInteractorStep` — business logic stays in the interactor
- `testShowDetailPushesRoute` — only the router mutates navigation state
- `testWillDeinitResetsInteractor` — teardown semantics
- `testModuleHolderDeinitSchedulesTeardownOnMainActor` — teardown delivered async on the MainActor
- `testPresenterIsAliveDuringTeardownThenReleased` — presenter alive during teardown, freed after (no leak)
- `testDetailModuleRendersDescription` — independent child module
