import Foundation

let allDiscussionCards: [DiscussionCard] = [

    // MARK: - Architecture

    DiscussionCard(
        question: "How would you design an image loading and caching library from scratch?",
        answer: """
        Key talking points:

        Layers:
        1. Memory cache (NSCache) — fast, auto-evicted under memory pressure
        2. Disk cache — persistent, needs expiration policy (TTL, LRU eviction)
        3. Network layer — URLSession download tasks, request deduplication (don't fetch same URL twice concurrently)

        Request pipeline: URL → check memory → check disk → fetch network → decode → cache → deliver

        Async/SwiftUI integration: async image loading with placeholder and error states. Consider Task cancellation when cell/view disappears.

        Deduplication: use a dictionary of [URL: [continuation]] to coalesce multiple requests for the same URL into one network call.

        Image decoding: decode off-main-thread to avoid blocking UI. Pre-scale to display size before caching.

        Bonus: progressive JPEG, WebP support, ETags for cache validation.
        """,
        difficulty: .hard,
        topic: .architecture
    ),
    DiscussionCard(
        question: "How would you architect an offline-first iOS app?",
        answer: """
        Core principles:

        Local-first data: app reads/writes local store (Core Data, SwiftData, SQLite) always. Network sync happens in background.

        Sync strategy:
        • Last-write-wins: simplest, works when conflicts are rare
        • Operation-based CRDT: append-only log of operations, merge without conflict
        • Timestamp + server reconciliation: server resolves conflicts

        Components:
        • Local persistence layer (Core Data stack with persistent history tracking)
        • Sync engine: monitors connectivity, queues outgoing changes, applies incoming deltas
        • Conflict resolution policy (configurable per entity)

        NSPersistentCloudKitContainer: Apple's built-in option for CloudKit sync — good starting point, discuss limitations.

        Challenges: deletions (tombstones), pagination (what to cache), binary data (media files).

        Testing: use XCTest + mock network to simulate offline/online transitions.
        """,
        difficulty: .hard,
        topic: .architecture
    ),
    DiscussionCard(
        question: "How would you architect a real-time chat application in iOS?",
        answer: """
        Key components:

        Transport: WebSocket (URLSessionWebSocketTask) for persistent bidirectional connection. Fall back to long-polling if needed.

        Message model: unique ID, sender, timestamp, content, delivery status (sent/delivered/read).

        Local persistence: store messages in Core Data or SQLite for instant load and offline reading.

        State management: message list as a sorted array in a ViewModel. New messages appended, status updates mutate existing items.

        Optimistic UI: show message immediately in "sending" state; update to "sent" on server ACK; revert to "failed" on error.

        Reconnection: exponential backoff, message queue flushed on reconnect, sequence numbers to detect gaps.

        Push notifications: APNs for background delivery when socket is disconnected.

        Media: upload to S3/CDN, send URL in message, lazy-load in UI.
        """,
        difficulty: .hard,
        topic: .networking
    ),
    DiscussionCard(
        question: "Describe your approach to designing a networking layer for a complex iOS app.",
        answer: """
        Goals: testable, composable, cancellable, handles auth transparently.

        Protocol abstraction:
            protocol NetworkClient {
                func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
            }

        Endpoint model: encapsulates URL, method, headers, body — makes each API call a value type, easy to test.

        Interceptors / middleware: auth token injection, request logging, retry logic, response validation.

        Token refresh: use an actor to serialize refresh requests — if token is expired, one task refreshes while others wait, then all proceed with new token.

        Error model: typed errors (NetworkError with cases for unauthorized, notFound, serverError, decodingFailure) — callers get actionable information.

        Testing: URLProtocol stub that intercepts requests — no mocking URLSession, tests run fully.
        """,
        difficulty: .hard,
        topic: .networking
    ),
    DiscussionCard(
        question: "How would you implement pagination in a list view?",
        answer: """
        Common patterns:

        Cursor-based pagination (preferred): server returns a cursor/token with each page. Client sends cursor to get next page. Stable under insertions/deletions.

        Offset-based: simpler but unstable (items shift if new content inserted at top).

        Implementation in SwiftUI:
        • Append items to array as pages load
        • Detect approaching end: .onAppear on the last visible cell → trigger next page load
        • Or: .task(id: items.count) on a sentinel item at the bottom

        State machine: idle, loading, loaded, error, exhausted. Prevents duplicate requests.

        Prefetching: UICollectionViewDataSourcePrefetching / prefetchTask trigger load before user scrolls to end.

        Error recovery: show retry button at bottom of list on failure.
        """,
        difficulty: .medium,
        topic: .architecture
    ),

    // MARK: - Performance

    DiscussionCard(
        question: "How would you debug and fix a memory leak discovered in production?",
        answer: """
        Investigation:
        1. Reproduce locally if possible — enable Malloc Stack Logging
        2. Xcode Memory Graph Debugger: find objects that should have been deallocated (e.g., VCs after dismissal)
        3. Instruments → Allocations: look for monotonically growing object count
        4. Instruments → Leaks: identifies unreachable allocations

        Common culprits:
        • Closure capturing self strongly (fix: [weak self])
        • Delegate properties not declared weak
        • NotificationCenter observer not removed in deinit
        • Timer with a strong reference to self
        • Singleton holding strong reference to transient objects

        Production signals: MetricKit memory metrics, crash reports from OOM (jetsam), custom analytics tracking memory footprint.

        Prevention: memory leak test in XCTestCase using addTeardownBlock with a weak reference.
        """,
        difficulty: .medium,
        topic: .performance
    ),
    DiscussionCard(
        question: "How would you optimize a slow SwiftUI list with complex cells?",
        answer: """
        Diagnosis first: use Instruments → SwiftUI profiler to see which views are re-rendering unnecessarily.

        Strategies:
        1. Equatable conformance: if cell data is Equatable and unchanged, SwiftUI can skip diffing it
        2. Extract cell into separate struct: limits re-render scope to just that view
        3. Avoid expensive computations in body: move to ViewModel or use lazy properties
        4. LazyVStack in ScrollView: don't render off-screen cells
        5. Image loading: async + cache to avoid blocking layout
        6. Reduce modifier chains: each modifier adds a wrapper view to the type hierarchy

        List vs LazyVStack: List has built-in lazy loading, pull-to-refresh, swipe actions — prefer it for standard lists. LazyVStack for custom scroll behavior.

        @State vs @ObservedObject granularity: if a large object changes, all views observing it re-render. Split into smaller, focused observable objects.
        """,
        difficulty: .medium,
        topic: .performance
    ),

    // MARK: - System Design

    DiscussionCard(
        question: "Design a social media feed (like Instagram) for an iOS app.",
        answer: """
        Layers:

        Data model: Post (id, author, media URL, caption, likeCount, timestamp), pagination cursor.

        Network: paginated endpoint, cursor-based. Background refresh on pull-to-refresh or app foregrounding.

        Local cache: Core Data or SQLite stores recent N posts for instant load. Separate media cache (disk) for images/video thumbnails.

        UI: SwiftUI List or UICollectionView with compositional layout. Cells: async image load, interaction buttons.

        Real-time updates: WebSocket or polling for like/comment counts. Optimistic UI for local user's actions.

        Media prefetching: prefetch next N images as user scrolls.

        Stories/Reels: separate carousel; full-screen AVPlayer for video; preload next video while current plays.

        Offline: show cached feed with staleness indicator.
        """,
        difficulty: .hard,
        topic: .architecture
    ),
    DiscussionCard(
        question: "How would you implement a feature flag system for iOS?",
        answer: """
        Goals: enable/disable features without an App Store release, support A/B testing, gradual rollout.

        Remote config source: Firebase Remote Config, LaunchDarkly, or custom endpoint returning JSON flag definitions.

        Local fallback: bundle a default flags JSON — app works even if remote fetch fails.

        Swift API:
            enum Feature: String { case newCheckout, darkModeV2 }
            FeatureFlags.shared.isEnabled(.newCheckout)

        Flag types: boolean on/off, percentage rollout (hash user ID for determinism), variant strings for A/B.

        Caching: cache fetched config locally, refresh on app foreground. Background fetch for always-fresh values.

        Testing: protocol abstraction for FeatureFlagService lets you inject a test double with any flag state.

        Analytics: log which variant a user is in to properly attribute metrics.
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    DiscussionCard(
        question: "How would you handle authentication and token refresh in an iOS app?",
        answer: """
        Storage: access token in Keychain (not UserDefaults — not encrypted). Refresh token in Keychain with kSecAttrAccessibleAfterFirstUnlock for background refresh capability.

        Token lifecycle:
        • Access token: short-lived (15 min–1 hr), sent with every request
        • Refresh token: long-lived, used only to get a new access token

        Refresh strategy (Actor-based):
            actor AuthManager {
                private var isRefreshing = false
                private var waiters: [CheckedContinuation<String, Error>] = []
                func validToken() async throws -> String { ... }
            }
        Only one refresh happens at a time; concurrent requests wait and all get the new token.

        401 handling: interceptor in networking layer detects 401, triggers refresh, retries original request transparently.

        Biometrics: use LocalAuthentication for FaceID/TouchID before retrieving token from Keychain.

        Logout: delete both tokens from Keychain, clear in-memory state, reset navigation stack.
        """,
        difficulty: .hard,
        topic: .networking
    ),
    DiscussionCard(
        question: "How would you migrate a large UIKit codebase to SwiftUI?",
        answer: """
        Strategy: incremental, not big-bang rewrite. Both can coexist.

        UIHostingController: wrap SwiftUI views for use in UIKit navigation stacks and view hierarchies.

        UIViewRepresentable / UIViewControllerRepresentable: embed UIKit components in SwiftUI when needed (maps, video players, web views, complex text input).

        Start at leaf nodes: replace simple, isolated UI components first (cells, alerts, small forms) — lower risk, learnings inform larger migrations.

        State management bridge: use ObservableObject VMs that work with both UIKit (combine subscribers) and SwiftUI (@ObservedObject).

        Navigation: defer navigation migration last — it's the most complex part. Coordinator pattern in UIKit can coexist with NavigationStack in SwiftUI screens.

        Team strategy: train on SwiftUI in new feature work; migrate old screens during refactoring cycles.

        Red flags to call out: timeline pressure, inadequate SwiftUI team experience, missing UIKit parity features (some complex layouts still require UIKit).
        """,
        difficulty: .hard,
        topic: .swiftUI
    ),
    DiscussionCard(
        question: "How do you approach accessibility in iOS apps?",
        answer: """
        Foundation: all interactive elements need accessibilityLabel, accessibilityHint, accessibilityTraits.

        SwiftUI: most standard controls are accessible by default. Custom views need .accessibilityLabel(), .accessibilityElement(children:), .accessibilityAction().

        UIKit: set accessibilityLabel, isAccessibilityElement, accessibilityTraits on custom views. Use accessibilityActivate() for custom activation.

        Dynamic Type: use .font(.body) style fonts that respond to user's text size setting. Test at all sizes, especially Accessibility XXL. Avoid fixed heights that clip text.

        Color contrast: WCAG AA minimum 4.5:1 for normal text, 3:1 for large text. Use Xcode's color contrast checker.

        VoiceOver testing: navigate your app entirely with VoiceOver on a real device — reveals issues no code review will.

        Reduced motion: check UIAccessibility.isReduceMotionEnabled; provide non-animated alternatives.

        Audit tools: Accessibility Inspector in Xcode, automated via XCUITest accessibility audits (iOS 17).
        """,
        difficulty: .medium,
        topic: .uiKit
    ),
    DiscussionCard(
        question: "What are the trade-offs between MVC, MVVM, and TCA for iOS apps?",
        answer: """
        MVC:
        + Simple, Apple's default, less boilerplate for small screens
        - ViewController bloat, hard to test UI logic, tight coupling

        MVVM:
        + Testable business logic in ViewModel, clean binding in SwiftUI
        + Widely understood, easy to onboard
        - Binding boilerplate in UIKit (Combine or RxSwift needed), ViewModel can itself grow large
        - No standard navigation solution

        TCA (The Composable Architecture):
        + Unidirectional data flow — predictable state mutations via actions/reducers
        + Excellent testability (deterministic, time-travel debugging)
        + Composable: feature stores compose into parent stores
        - Steep learning curve, heavy boilerplate
        - Overhead may not be worth it for simple features

        Senior take: choose based on team experience and app complexity. MVVM works well for most apps. TCA shines in complex, state-heavy apps with large teams.
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    DiscussionCard(
        question: "How would you implement deep links in an iOS app?",
        answer: """
        Types:
        • URL Schemes: myapp://path/to/content (older, any app can open)
        • Universal Links: https://yourdomain.com/path (Apple Verified, harder to hijack)

        Routing:
        • Parse incoming URL in Scene/AppDelegate
        • Route to correct screen by updating NavigationPath or presenting appropriate VC
        • Handle both cold start (app not running) and warm start (app in background)

        Implementation:
            .onOpenURL { url in
                router.handle(url)
            }

        Router design: DeepLinkRouter parses URL path components and query params, maps to a typed DeepLinkDestination enum, then coordinator/NavigationPath handles navigation.

        Cold start: store pending deep link destination; navigate after app finishes initialization.

        Testing: write unit tests for URL parsing logic (doesn't require UI). XCUITest for end-to-end navigation.

        Edge case: user is not authenticated — deep link after login completion.
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    DiscussionCard(
        question: "How do you approach CI/CD for an iOS project?",
        answer: """
        Build pipeline stages:
        1. lint (SwiftLint)
        2. build
        3. unit tests
        4. UI tests (subset — full suite too slow for every PR)
        5. archive + export IPA
        6. distribute (TestFlight / App Store)

        Tools: Xcode Cloud (integrated, no infrastructure), Fastlane (flexible, cross-platform), GitHub Actions + self-hosted Mac runner.

        Fastlane lanes:
        • test — run test suite
        • beta — bump build number, archive, upload to TestFlight
        • release — full release pipeline with screenshots, metadata sync

        Code signing: Match tool — certificates and profiles stored in a private git repo, fetched by CI. Team shares via same Apple ID or App Store Connect API key.

        Branching strategy: PRs run test lane; merges to main trigger beta lane; tags trigger release lane.

        Speed: parallelize UI tests across multiple simulators (Xcode parallelization), cache Swift Package Manager dependencies.
        """,
        difficulty: .medium,
        topic: .testing
    ),
    DiscussionCard(
        question: "How would you design a logging and analytics system for an iOS app?",
        answer: """
        Concerns: privacy, performance, reliability, debuggability.

        Logging levels: debug / info / warning / error. In production: warning and above only (or error only) to reduce data.

        Structured logging: log events as structured data (event name + properties dictionary) rather than plain strings — enables analytics dashboards.

        Privacy: never log PII (email, name, phone) directly. Use anonymized IDs. Document what's logged for App Privacy report.

        Batching: queue events in memory, flush to server every N seconds or N events or on app background. Persist queue to disk so events survive crashes.

        Multiple destinations: unified logger that routes to console (debug), Crashlytics (errors), analytics backend (events). Abstract behind protocol so destinations are swappable.

        Testing: mock analytics client to assert correct events are fired in unit tests.

        Performance: all logging off main thread. Use os_log for system-level integration.
        """,
        difficulty: .medium,
        topic: .performance
    ),
    DiscussionCard(
        question: "How would you handle sensitive user data and security in an iOS app?",
        answer: """
        Data at rest:
        • Keychain: credentials, tokens, encryption keys — uses hardware secure enclave on modern devices
        • NSFileProtection: file-level encryption tied to device passcode
        • Never use UserDefaults or plain files for sensitive data
        • Core Data: enable NSPersistentStoreFileProtectionKey

        Data in transit:
        • HTTPS only — App Transport Security enforced
        • Certificate pinning: compare server cert against known-good hash — prevents MITM even with compromised CA
        • But: handle pinning failures gracefully (rotation)

        Code security:
        • No secrets in source code — use server-side config or encrypted bundles
        • Jailbreak detection (defensive, not foolproof)
        • Obfuscation has limited value — don't over-invest

        User privacy:
        • Minimal data collection
        • App Privacy Nutrition Labels accurate
        • Honor ATT framework for tracking consent
        """,
        difficulty: .hard,
        topic: .networking
    ),
    DiscussionCard(
        question: "How would you implement a custom animation in SwiftUI?",
        answer: """
        Basic animations: .animation(.spring(), value: someState) or withAnimation { } block.

        Custom timing: Animation.timingCurve(c0x:c0y:c1x:c1y:duration:) for Bezier curves.

        Keyframe animations (iOS 17): KeyframeAnimator — define multiple waypoints with different timing for complex sequences.

        GeometryEffect: apply custom transformations (rotation, scale, distortion) that can be animated.

        AnimatableData protocol: make a custom ViewModifier animatable by conforming to Animatable and exposing animatableData (must be VectorArithmetic-conforming).

        PhaseAnimator (iOS 17): cycle through a sequence of phases, each with its own view state and animation.

        Matched Geometry Effect: .matchedGeometryEffect(id:in:) — smoothly animate views between different positions in the layout (hero transitions).

        Performance: prefer animating transforms and opacity over layout changes — these run on the compositor thread.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
]
