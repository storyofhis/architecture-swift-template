# SwiftUI Best Practices Guide

This started as a one-off review of this repo. It's now a standing guide: a checklist of SwiftUI/Swift conventions this template follows, **why** each one matters, and the mistakes beginners most commonly make when starting their first SwiftUI project. Every rule below is already applied somewhere in this codebase — when in doubt, go read the real file referenced next to the rule.

Pair this with `README.md`: the README explains *how the architecture is organized* (layers, DI, how to add a feature). This doc explains *how to write the code that goes inside it* without picking up bad habits.

---

## How to use this doc if you're new to Swift/SwiftUI

1. Before writing a new feature, skim the checklist headers below — they're the categories of mistakes that are easy to make on your first project.
2. When you copy a pattern from this repo (e.g. `HomeViewModel`, `GetWeatherForecastRequest`), you're copying something that already follows these rules. Copy the *shape*, not just the code.
3. When something in your own code feels awkward to write (a huge `body`, a button that needs three lines to do one thing), it's usually a sign one of these rules applies — the "why" explanations below will tell you which one.

---

## 1. State & Data Flow

**Use `@Observable` + `@State`, never `ObservableObject`/`@Published`/`@StateObject`.**

*Why:* `@Observable` (Swift's `Observation` framework) tracks exactly which properties a view actually reads, so a view only redraws when data it uses changes — not on every property change anywhere in the model. It also means one less import (`Combine` isn't needed) and no `$` publisher boilerplate.

```swift
// Don't
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var current: CurrentWeather?
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
}

// Do — see Features/Home/HomeViewModel.swift
@Observable
@MainActor
final class HomeViewModel {
    var current: CurrentWeather?
}

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}
```

**A ViewModel is always `@MainActor`.** All UI-facing state mutation happens on the main actor — this is what prevents "purple runtime warning" crashes about publishing changes from a background thread.

**Prefer `Date`/`Measurement`/plain value types over pre-formatted `String` properties.** Format at the point of display (`Text(_:format:)`), not at the point of fetch. It's cheaper (no `DateFormatter` allocation per fetch) and keeps the ViewModel unaware of presentation. See `HomeViewModel.current` (a `CurrentWeather?`, not a formatted string) and `WeatherHeroView` (does the formatting).

---

## 2. Views & Composition

**One `View` struct per file — extract sections into real `View` structs, not computed `some View` properties.**

*Why:* a computed property still lives inside the parent's `body`, so it re-evaluates every time the parent redraws, and it can't have its own `#Preview`. A real `View` struct is independently previewable, independently testable for layout, and only redraws when *its own* inputs change.

```swift
// Don't
private var counterRow: some View {
    HStack { Text("Counter"); Spacer(); Text("\(counter)") }
}

// Do — its own file, its own #Preview
struct CounterRow: View {
    let counter: Int
    var body: some View {
        HStack { Text("Counter"); Spacer(); Text("\(counter)") }
    }
}
```

**Split each feature folder into `View/` and `UI/`.** `View/` is for screens and feature-specific compositions that own navigation, presentation, or a particular layout (`HomeView`, `WeatherHeroView`, `WeatherAttributionSheet`). `UI/` is for small, reusable, purely-presentational pieces that just take data and render (`WeatherDetailTile`, `HourlyForecastTile`, `WeatherBackground`). See `Features/Home/View/` and `Features/Home/UI/` for the worked example. This split is what keeps a feature folder navigable once it grows past 3–4 files — without it, everything ends up flattened into one folder and you can't tell a screen from a component at a glance.

**Drive async work with `.task`, not `.onAppear` + a manually-spawned `Task`.** `.task` is cancelled automatically when the view disappears; a `Task {}` started inside a method is not, so it can keep running (and mutating state) after the user has navigated away.

```swift
// Don't
.onAppear { viewModel.getData() }   // internally does Task { ... }

// Do
.task { await viewModel.fetchData() }
```

**Pass button actions directly instead of wrapping them in a closure.**
```swift
// Don't
Button("Increment") { viewModel.increment() }

// Do
Button("Increment", action: viewModel.increment)
```

**Use `ContentUnavailableView` for empty/error states instead of a custom `Text`.** It's free accessibility and layout correctness — see the error branch in `HomeView`.

---

## 3. Networking

**Model each request as its own `struct` conforming to a shared protocol — never a monolithic "API manager" with one method per endpoint.**

*Why:* each request is independently testable, independently mockable, and adding a new endpoint never touches a file another endpoint depends on (no merge conflicts).

```swift
protocol APIRequest {
    associatedtype Response: Decodable
    associatedtype Body: Encodable = EmptyBody

    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
    var body: Body? { get }
}
```
See `Core/Service/GetWeatherForecastRequest.swift` for a real example, and `Core/Networking/APIClient.swift` for the one place that actually executes them.

**Never force-unwrap URL construction — make the failure throw instead.** A hardcoded typo in a URL string shouldn't be able to crash the app in production; it should surface as a normal, catchable error.

```swift
// Don't
func makeURL<T: APIRequest>(for request: T) -> URL {
    var components = URLComponents(url: ..., resolvingAgainstBaseURL: false)!
    return components.url!
}

// Do — see Core/Networking/APIClient.swift
func makeURL<T: APIRequest>(for request: T) throws -> URL {
    guard var components = URLComponents(url: ..., resolvingAgainstBaseURL: false) else {
        throw APIError.invalidURL
    }
    guard let url = components.url else { throw APIError.invalidURL }
    return url
}
```

**Extract hardcoded, demo-specific values into an injectable model instead of repeating a literal across files.** The Weather demo's city ("Jakarta") used to be duplicated as a literal in the API request's coordinates *and* in two different views — three places to update if the demo city ever changed, and easy to let them drift out of sync. It's now one `WeatherLocation` value, injected through `HomeViewModel`. If you find yourself typing the same literal in more than one file, that's the signal to do this.

**DTO properties should be `camelCase` with `CodingKeys` mapping to the wire format — never leave a property as raw `snake_case`.**
```swift
struct CurrentWeather: Decodable {
    let weatherCode: Int   // not weather_code

    enum CodingKeys: String, CodingKey {
        case weatherCode = "weather_code"
    }
}
```

---

## 4. Accessibility & Design

**Never hardcode font point sizes — build typography on Dynamic Type text styles.** A fixed `.font(.system(size: 27))` never scales for a user who has increased their system text size; `.font(.title.bold())` does, automatically.

```swift
// Don't
.font(.system(size: 27, weight: .bold))

// Do — see Core/UI/FontStyle.swift
.font(.title.bold())
```
If you truly need a custom size (like the giant hero temperature in `WeatherHeroView`), scale it with `@ScaledMetric` rather than hardcoding a raw number — that way it still grows with Dynamic Type instead of staying frozen.

**Use `foregroundStyle()`, not the deprecated `foregroundColor()`.**

**Prefer the system's own components over hand-rolled versions of them.** This template uses Apple's native Liquid Glass APIs directly rather than reinventing them:
* `.glassCard()` (`Core/UI/GlassCard.swift`) wraps a view in `.glassEffect(_:in:)` for a rounded glass card.
* `.buttonStyle(.glass)` / `.buttonStyle(.glassProminent)` — Apple's own glass button styles — instead of a custom `ButtonStyle` reimplementing the same look.
* `Label`, `LabeledContent`, `Grid`/`GridRow`, `ContentUnavailableView` — reach for these before building an `HStack` + `Image` + `Text` combo from scratch.

**Icon-only buttons still need a text label for VoiceOver**, even if you only want the icon visible: `Button("Weather Conditions", systemImage: "info.circle") { ... }.labelStyle(.iconOnly)`. This keeps the visual icon-only look while VoiceOver still announces "Weather Conditions."

---

## 5. Naming & Hygiene

**Don't give your own types the same name as a framework type.** `enum Environment` in this codebase used to shadow SwiftUI's own `@Environment` property wrapper — harmless until some file needed both, at which point it's an ambiguity error. It's now `AppEnvironment`. Before naming a new top-level type, do a quick mental check against common SwiftUI/Foundation names (`Environment`, `State`, `Binding`, `Task`, `Response`, ...).

**One type (struct/class/enum) per file.** Easier to find, easier to review, easier to keep the "View vs UI" split honest.

**Keep file header comments in sync with the actual filename**, especially after a rename — a stale header pointing at a deleted filename is a small thing, but it's exactly the kind of paper cut that makes a beginner reading unfamiliar code assume they're missing context that isn't actually there.

---

## Common first-project mistakes this template already avoids

If you're new to Swift/SwiftUI, these are the traps most beginners fall into on their first real project — all called out above, collected here as a quick gut-check list:

- Reaching for `ObservableObject`/`@Published` out of habit (from older tutorials) instead of `@Observable`
- Writing all business logic directly inside a view's `body` or `.onAppear`, instead of a ViewModel
- One giant `View` file with a 300-line `body`, instead of extracting subviews into their own files
- Force-unwrapping (`!`) anything that touches the network or user input
- Copy-pasting the same URL/string constant into multiple files "just for now"
- Fixed font sizes and colors sprinkled everywhere instead of a small shared design system
- Icon-only buttons with no accessibility label
- `DispatchQueue.main.async` instead of `async`/`await` and `@MainActor`

---

## Applied history (for provenance)

Everything above has actually been applied to this repo, in roughly this order:

1. **Initial modernization pass** — migrated `HomeViewModel`/`HomeView` from `ObservableObject`/`@StateObject` to `@Observable`/`@State`; fixed the `Environment` → `AppEnvironment` naming collision; made `APIClient`'s URL construction throw instead of force-unwrapping; unified two inconsistent fetch patterns into `.task`-driven `async` functions; fixed `foregroundColor` → `foregroundStyle` and other small modern-API cleanups.
2. **XcodeGen adoption** — replaced the committed `.xcodeproj` with a `project.yml` spec (gitignoring the generated project file) to avoid `.pbxproj` merge conflicts.
3. **Feature rewrite** — replaced the Indodax crypto ticker demo with a native-style Weather screen backed by Open-Meteo: hero header, hourly forecast scroll, detail grid, and a "Weather Conditions" attribution sheet, built from Apple's Liquid Glass APIs (`.glassEffect()`, `.buttonStyle(.glass)`) plus a custom `.glassCard()` modifier.
4. **Cleanup** — removed the now-unrelated counter/increment demo feature and its now-orphaned `AppPrimaryButtonStyle`.
5. **Folder reorganization** — split `Features/Home/` into `View/` and `UI/`, and extracted the repeated "Jakarta" literal into an injectable `WeatherLocation` model.
