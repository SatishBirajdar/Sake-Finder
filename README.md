# Sake Finder

A small SwiftUI iOS app for discovering Nagano sake shops. It demonstrates a clean
MVVM architecture with dependency injection, a reusable design-system layer, an
image-caching layer, and unit + snapshot tests.

## About the project

Sake Finder is a two-tab iOS application built entirely in SwiftUI. It loads a list
of sake shops (from a bundled JSON sample, or optionally a remote endpoint), lets
the user browse and search them, view rich detail pages, and save favourites that
persist across launches.

The project is intentionally written as a reference for production-quality iOS
practices rather than a throwaway prototype:

- **MVVM in a modular, layered structure** — Models, Services, Persistence,
  ViewModels, Views, and a Support/design-system layer are cleanly separated.
- **SOLID + dependency injection** — views and view models depend on protocols
  (`SakeServiceProtocol`, `FavouritesStoring`), not concrete types, so the
  networking and persistence layers are swappable and testable.
- **No code duplication / one type per file** — shared behaviour is extracted into
  reusable components (`RemoteImageView`, `FavouriteButton`, `CardBackground`, …)
  and constants are centralised (`AppTheme`, `AppStrings`).
- **Proper networking layer** — typed errors with user-facing feedback and a retry
  affordance.
- **Tested** — unit tests with dedicated mock files, plus snapshot tests for the UI
  components.
- **Documented** — inline documentation across types and this README.

| | |
|---|---|
| Platform | iOS (iPhone & iPad) |
| UI framework | SwiftUI |
| Architecture | MVVM + protocol-oriented DI |
| Version | 1.0 |
| Bundle identifier | `com.sam.sake-finder` |

## Features

- **Popular tab** — searchable, pull-to-refresh list of sake shops.
- **Favourite tab** — shops you've hearted, with an empty state.
- **Favourites** — tap the heart on any row or on the detail screen; the count is
  shown as a badge in the navigation bar. Persisted across launches.
- **Detail screen** — hero image with a gradient scrim + name overlay, star
  rating, description, and links to Google Maps and the shop's website.
- **Search** — debounced filtering via the system search bar.
- **Resilient images** — a caching/downsampling loader with placeholder and
  failure states.

## Requirements

| Tool / setting | Version |
|---|---|
| macOS | 13 Ventura or later (to run Xcode 15+) |
| Xcode | 15.0 or later |
| iOS deployment target | 17.6 |
| Swift | 6.0 (app target), 6.0 (test target) |
| Devices | iPhone and iPad (universal) |
| Internet | Only needed once, to resolve the SPM test dependency; the app itself runs offline |

The features used — `NavigationStack`, `.searchable`, `.refreshable`,
`.sensoryFeedback`, `.symbolEffect`, `ImageRenderer`-based snapshots, value-based
navigation — require **iOS 16+**, and the project targets **iOS 17.6**.

## Dependencies

The **application target has zero third-party runtime dependencies** — it uses only
Apple frameworks (SwiftUI, Foundation, UIKit/`ImageIO` for image downsampling).

The **test target** uses one Swift Package Manager dependency:

| Package | Version | Scope | Purpose |
|---|---|---|---|
| [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | `1.17.0` (up to next major) | Test target only | Records and compares snapshot images of the UI components |

It is declared in the Xcode project (`project.pbxproj`) as a remote SPM package and
linked into the `Sake FinderTests` target. Xcode resolves it automatically on first
open; the resolved versions are pinned in
`Sake Finder.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

## Setup

1. **Clone / open** — open `Sake Finder.xcodeproj` in Xcode 15 or later.
2. **Resolve packages** — let SPM resolve `swift-snapshot-testing`. If it doesn't
   start automatically, run **File → Packages → Resolve Package Versions**
   (requires internet access).
3. **Select the scheme** — choose the **Sake Finder** scheme and an iOS 17
   simulator (iPhone 15 recommended, to match the snapshot references).
4. **Run** the app with **⌘R**.
5. **Test** with **⌘U** (see [Testing](#testing)).

> The app ships with a bundled `sample-sake-response.json` and loads it by default,
> so it works fully offline with no backend configuration.

## Architecture

The app follows **MVVM** with a layered, protocol-oriented design so that
networking and persistence can be swapped or mocked.

```
SwiftUI Views  ──observe──▶  ViewModel  ──depends on──▶  Service / Store protocols
                                                          │
                                          SakeAPIClient ──┘   FavouritesStore
```

- **Views** are presentation-only and compose small reusable components.
- **`SakeListViewModel`** (`@MainActor`, `ObservableObject`) owns data loading,
  loading/error state, search filtering and retry. Its data source is injected as
  a `SakeServiceProtocol`.
- **Networking** is abstracted behind `SakeServiceProtocol`; `SakeAPIClient`
  validates the HTTP response, maps failures to a typed `SakeServiceError`
  (`LocalizedError` with user-facing copy), and falls back to bundled sample data.
- **Persistence** is abstracted behind `FavouritesStoring`; `FavouritesStore`
  persists favourites to an injectable `UserDefaults`.
- **Design system** lives in `Support/` (`AppTheme` for layout + SF Symbol names,
  `AppStrings` for copy) and `Views/Components/` (reusable views/modifiers).
- **Images** load through `ImageLoader`, an `actor` that caches (`NSCache`),
  de-duplicates in-flight requests, and downsamples with ImageIO so thumbnails
  don't hold full-resolution bitmaps.

## Project structure

```
Sake Finder/
├── Sake_FinderApp.swift          App entry point
├── Models/
│   └── SakeShop.swift
├── Services/                     Networking + image loading
│   ├── SakeServiceProtocol.swift
│   ├── SakeAPIClient.swift
│   ├── SakeServiceError.swift
│   ├── APIConfiguration.swift
│   └── ImageLoader.swift
├── Persistence/
│   ├── FavouritesStoring.swift
│   └── FavouritesStore.swift
├── ViewModels/
│   └── SakeListViewModel.swift
├── Views/
│   ├── LaunchView.swift
│   ├── MainTabView.swift
│   ├── SakeListView.swift
│   ├── FavouritesView.swift
│   ├── SakeDetailView.swift
│   └── Components/               Reusable UI
│       ├── RatingView.swift
│       ├── RemoteImageView.swift
│       ├── FavouriteButton.swift
│       ├── FavouritesBadge.swift
│       ├── SakeShopRow.swift
│       ├── ShopListView.swift
│       ├── MessageView.swift
│       ├── CardBackground.swift
│       └── CardButtonStyle.swift
├── Support/
│   ├── AppTheme.swift            Layout metrics + SF Symbol names
│   └── AppStrings.swift          User-facing copy
└── Resources/
    ├── Assets.xcassets
    └── sample-sake-response.json

Sake FinderTests/
├── SakeListViewModelTests.swift
├── SakeShopTests.swift
├── FavouritesStoreTests.swift
├── SakeServiceErrorTests.swift
├── SakeFinderSnapshotTests.swift
├── TestFixtures.swift            Shared fixtures + helpers
└── Mocks/
    └── MockSakeService.swift
```

## Configuration

`SakeAPIClient` is driven by `APIConfiguration`:

- `shopsEndpoint` — remote URL for the shop list. When `nil` (the default), the
  client loads the bundled `sample-sake-response.json`.
- `sampleResourceName` — the bundled JSON filename used for the offline fallback.

To point the app at a real backend, pass a configuration with a non-nil endpoint
when constructing `SakeAPIClient`.

## Testing

Run all tests with **⌘U** (or `Product → Test`).

- **Unit tests** cover the view model (load/retry/error/search), the model's URL
  helpers, the favourites store (toggle + persistence), and the error type's
  user-facing descriptions. A `MockSakeService` lives in `Mocks/`.
- **Snapshot tests** (`SakeFinderSnapshotTests`) use
  [swift-snapshot-testing]
  to verify the reusable components (`RatingView`, `FavouritesBadge`,
  `MessageView`, `SakeShopRow`).

### Recording snapshots

Reference images live in `Sake FinderTests/__Snapshots__/`. The first run records
them (and fails), so commit the generated images and subsequent runs will compare
against them.

> ⚠️ Record and compare on a **consistent simulator** (authored against iPhone 15,
> iOS 17). Fonts and screen scale differ across devices and will cause spurious
> failures otherwise.

## AI use

This project was developed with the assistance of an AI coding agent
(Anthropic's Claude, via Claude Code). AI involvement is disclosed here in the
interest of transparency.

**What AI was used for:**

- Refactoring the initial code into the MVVM + layered architecture.
- Generating reusable components, the image-caching loader, view models, and the
  unit + snapshot test scaffolding.
- Wiring new files and the SPM dependency into the Xcode project, and authoring
  this documentation.
- Suggesting UI/UX, performance, and stability improvements.

**How the output was handled:**

- All AI-generated changes were directed, reviewed, and iterated on by a human
  developer, who made the design decisions and accepted/rejected suggestions.
- The agent's environment could not run a full Xcode build or the simulator, so
  project-file edits were validated with `plutil`/integrity checks and sources were
  syntax-checked, but **final compilation, running the app, and recording snapshot
  references must be verified in Xcode** on a developer machine.

**Implications:** treat the code as a strong starting point that has been
human-reviewed for design, but give it the same build/test verification you would
any contribution before relying on it.

## Notes & known limitations

- `SakeShop.id` is a locally generated `UUID` and is not stable across decodes;
  favourites are therefore keyed by shop **name**.
- The networking layer is implemented but not exercised by default, since the
  app loads bundled sample data (`shopsEndpoint == nil`).
- Copy is centralised in `AppStrings` but not yet localised (no String Catalog).
