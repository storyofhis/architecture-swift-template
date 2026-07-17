# SwiftUI Best Practices Review

Review of `architecture-swift-template` against modern SwiftUI/Swift 6 conventions (iOS 26 target). Organized by file, highest-impact items first in the summary at the bottom.

**Status: all items below have been applied and verified with a successful `xcodebuild` for the iOS Simulator.** Kept as a record of what changed and why.

One deliberate behavior change worth flagging: the old code forced server time display into GMT+7 regardless of device settings; the new `Text(_:format:)` rendering uses the device's own locale/timezone instead. That's the more correct default for accessibility/localization, but call it out if GMT+7 was intentional for this Indonesia-only exchange.

## HomeViewModel.swift

**Migrate off `ObservableObject`/`@Published` to `@Observable`.**

This is the biggest structural change. `@Observable` is the modern replacement, gives finer-grained view updates, and drops the `Combine` import entirely.

```swift
// Before
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private let container: AppContainer
    @Published var counter: Int = 0
    @Published var btcPrice: String = "-"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var serverTime: String = "-"
    ...
}

// After
@Observable
@MainActor
final class HomeViewModel {
    private let container: AppContainer
    var counter: Int = 0
    var btcPrice: String = "-"
    var isLoading: Bool = false
    var errorMessage: String?
    var serverDate: Date?
    ...
}
```

**Two inconsistent fetch patterns (`fetchAPI()` via `.task`, `getAPI()` spawning its own internal `Task`).**

Make both plain `async` functions and drive them from `.task` in the view. Internally-spawned tasks aren't cancelled when the view disappears.

```swift
// Before
func getAPI() {
    Task {
        do {
            let response = try await container.api.execute(GetTickerRequest())
            if let btc = response.tickers["btc_idr"] {
                btcPrice = btc.last ?? "-"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// After
func fetchTicker() async {
    do {
        let response = try await container.api.execute(GetTickerRequest())
        if let btc = response.tickers["btc_idr"] {
            btcPrice = btc.last ?? "-"
        }
    } catch {
        errorMessage = error.localizedDescription
    }
}
```

**Store `Date`, not a pre-formatted `String`, and let the view format it.**

Avoids allocating a `DateFormatter` on every fetch and moves presentation into the view layer where it belongs.

```swift
// Before
let formatter = DateFormatter()
formatter.timeZone = TimeZone(secondsFromGMT: 7 * 3600)
formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
serverTime = formatter.string(from: date)

// After (in the view model)
serverDate = date

// After (in the view)
Text(viewModel.serverDate ?? .now, format: .dateTime.day().month().year().hour().minute().second())
```

## HomeView.swift

**`@StateObject` should become `@State` once the view model is `@Observable`.**

```swift
// Before
@StateObject var viewModel: HomeViewModel

// After
@State private var viewModel: HomeViewModel
```

**Body is split into computed properties (`templateStatusSection`, `counterRow`, `apiSection`) rather than extracted `View` structs.**

This is called out explicitly in the SwiftUI guidance: prefer real `View` structs in their own files over `some View` computed properties, even with `@ViewBuilder`. It also avoids re-evaluating unrelated sections every time `body` runs.

```swift
// Before
private var counterRow: some View {
    HStack {
        Text("Counter")
        Spacer()
        Text("\(viewModel.counter)").monospacedDigit()
    }
}

// After — separate file, e.g. CounterRow.swift
struct CounterRow: View {
    let counter: Int
    var body: some View {
        HStack {
            Text("Counter")
            Spacer()
            Text("\(counter)").monospacedDigit()
        }
    }
}
```

**`.foregroundColor(.red)` is deprecated.**

```swift
// Before
Text(error).foregroundColor(.red)

// After
Text(error).foregroundStyle(.red)
```

**Prefer passing the action directly instead of a trailing closure.**

```swift
// Before
Button("Increment") {
    viewModel.increment()
}

// After
Button("Increment", action: viewModel.increment)
```

**Redundant `.task` + `.onAppear` triggering two different fetches on the same section.**

Use two `.task` modifiers (or one `.task` that awaits both) instead of mixing `.onAppear` in — `.task` cancels automatically when the view disappears, `.onAppear` does not.

```swift
// Before
.task { await viewModel.fetchAPI() }
.onAppear { viewModel.getAPI() }

// After
.task { await viewModel.fetchServerTime() }
.task { await viewModel.fetchTicker() }
```

**No `#Preview` block.** Worth adding one for fast iteration in Xcode.

## FontStyle.swift

**Fixed point sizes ignore Dynamic Type entirely** (`.font(.system(size: 27, weight: .bold))`). This is an accessibility issue: users who increase text size system-wide get no scaling at all in this design system.

```swift
// Before
case .title:
    content
        .font(.system(size: 27, weight: .bold))
        .lineSpacing(6)

// After — base on a Dynamic Type text style so it scales
case .title:
    content
        .font(.title.bold())
```

If a specific custom size is truly required, use `@ScaledMetric` (iOS 18-) or `.font(.body.scaled(by:))` (iOS 26+) rather than a raw fixed size.

## AppButtonStyle.swift

**`RoundedRectangle(cornerRadius: 12, style: .continuous)` — `.continuous` is already the default, no need to specify it.**

```swift
// Before
RoundedRectangle(cornerRadius: 12, style: .continuous)

// After
RoundedRectangle(cornerRadius: 12)
```

Minor: the corner radius (`12`) and color (`.mint`) are hardcoded here rather than pulled from `DesignSystem` — worth centralizing alongside `FontStyle.swift`'s typography enum so the whole design system lives in one place.

## Core/Networking/APIClient.swift

**~~`enum Environment` shadows SwiftUI's `Environment` property wrapper.~~ Fixed — renamed to `AppEnvironment`.**

Any top-level type that reuses a framework name (`Environment`, `State`, `Binding`, `Task`, etc.) risks ambiguity the moment a file needs both the framework symbol and the app's own type. Checked the rest of the project's top-level types (`Endpoint`, `Log`, `AppContainer`, `KeyValueStore`, ...) — none of those collide.

```swift
// Before
enum Environment {
    case development
    case production
}
static let environment: Environment = .development

// After
enum AppEnvironment {
    case development
    case production
}
static let environment: AppEnvironment = .development
```

**Force-unwrapped URLs will crash instead of surfacing a recoverable error — and `APIError.invalidURL` already exists but is unused.**

```swift
// Before
static var baseURL: URL {
    switch environment {
    case .development:
        return URL(string: "https://indodax.com")!
    case .production:
        return URL(string: "https://indodax.com")!
    }
}

func makeURL<T: APIRequest>(for request: T) -> URL {
    var components = URLComponents(
        url: APIConfig.baseURL.appendingPathComponent(request.endpoint.path),
        resolvingAgainstBaseURL: false
    )!
    ...
    return components.url!
}

// After
func makeURL<T: APIRequest>(for request: T) throws -> URL {
    guard var components = URLComponents(
        url: APIConfig.baseURL.appendingPathComponent(request.endpoint.path),
        resolvingAgainstBaseURL: false
    ) else {
        throw APIError.invalidURL
    }

    if !request.endpoint.queryItems.isEmpty {
        components.queryItems = request.endpoint.queryItems
    }

    guard let url = components.url else {
        throw APIError.invalidURL
    }

    return url
}
```

`execute(_:)` would then `try makeURL(for: request)` and propagate the error instead of crashing.

## Core/Model/Response.swift

**`TimeResponse.server_time` breaks Swift naming conventions, while `Ticker` right next to it uses `CodingKeys` to map to camelCase.** Align the two for consistency.

```swift
// Before
struct TimeResponse: Decodable {
    let server_time: Int
}

// After
struct TimeResponse: Decodable {
    let serverTime: Int

    enum CodingKeys: String, CodingKey {
        case serverTime = "server_time"
    }
}
```

Also note: the file header comment still says `Model.swift` even though the file is `Response.swift` — stale comment worth fixing while you're in there.

---

## Summary (highest impact first)

1. **Data flow (high):** Move `HomeViewModel` from `ObservableObject`/`@Published`/`@StateObject` to `@Observable`/`@State`. Everything else in the view model touches this.
2. **Accessibility (high):** `FontStyle.swift`'s fixed font sizes don't respect Dynamic Type — real usability issue for any user with larger text sizes enabled.
3. **Correctness/robustness (medium):** `APIClient`'s force-unwrapped URL construction can crash; `APIError.invalidURL` already models the failure but is bypassed. Make `makeURL` throwing.
4. **Concurrency consistency (medium):** Unify `fetchAPI()`/`getAPI()` into two `async` functions both driven by `.task`, dropping the internally-spawned `Task` and the `.onAppear` call.
5. **View structure (medium):** Extract `HomeView`'s computed-property sections into real `View` structs in their own files.
6. **Modern API cleanup (low):** `foregroundColor` → `foregroundStyle`, drop redundant `.continuous`, prefer `Button("Increment", action:)`, format dates via `Text(_:format:)` instead of a manual `DateFormatter`.
7. **Consistency nit (low):** Give `TimeResponse` a `CodingKeys` mapping like `Ticker` already has, and fix the stale `Model.swift` file header comment in `Response.swift`.
