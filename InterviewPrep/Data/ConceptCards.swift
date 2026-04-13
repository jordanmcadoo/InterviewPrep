import Foundation

// MARK: - Swift Fundamentals

let swiftFundamentalsCards: [ConceptCard] = [
    ConceptCard(
        question: "What is the difference between value types and reference types in Swift?",
        answer: """
        Value types (structs, enums, tuples) are copied on assignment — each variable holds its own independent copy. Reference types (classes) share a single instance via pointers.

        Key consequences:
        • Structs are stack-allocated (generally); classes heap-allocated
        • Value types are implicitly thread-safe since each caller has their own copy
        • Classes support inheritance; structs do not
        • Use structs by default in Swift — they avoid aliasing bugs and are more predictable

        Classic interview trap: Swift's copy-on-write (COW) optimization means Array/Dictionary don't actually copy until mutation, so the cost is lower than it appears.
        """,
        difficulty: .easy,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "Explain Swift optionals and the different ways to unwrap them.",
        answer: """
        An Optional<T> is an enum with two cases: .some(T) and .none. It represents the possible absence of a value.

        Unwrapping methods:
        1. if let / guard let — conditional binding (safe)
        2. Optional chaining (foo?.bar?.baz) — returns nil if any step is nil
        3. Nil coalescing (??) — provides a default value
        4. Force unwrap (!) — crashes if nil; avoid except in tests or truly guaranteed values
        5. switch on the optional — exhaustive pattern matching
        6. Optional map/flatMap — functional transformation without unwrapping

        Interview tip: Discuss when force-unwrap is acceptable (IBOutlets, known-non-nil test data) vs. when it's a smell.
        """,
        difficulty: .easy,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is the difference between @escaping and non-escaping closures?",
        answer: """
        A non-escaping closure is guaranteed to be called before the function returns — the compiler can skip retain/release overhead and you can safely reference self without capture lists.

        An @escaping closure outlives the function call (stored for later async execution, e.g., a completion handler or stored property). You must:
        • Explicitly annotate the parameter with @escaping
        • Capture self strongly or weakly as appropriate

        Performance: Non-escaping closures are optimized more aggressively by the compiler. Prefer them when possible.

        Example: Array.map(_:) takes a non-escaping closure. URLSession.dataTask(completionHandler:) takes an escaping one.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "Explain protocols in Swift. How are they different from abstract classes?",
        answer: """
        A protocol defines a contract (methods, properties, initializers) without providing implementation. Any type — struct, class, or enum — can conform.

        Key advantages over abstract classes:
        • Value types can conform (structs/enums can't inherit classes)
        • A type can conform to multiple protocols (no multiple inheritance problem)
        • Retroactive conformance: extend types you don't own

        Protocol extensions provide default implementations. Combined with associated types and conditional conformances, this enables powerful protocol-oriented programming.

        When to use classes + inheritance: modeling true IS-A relationships, interop with ObjC, reference semantics needed (e.g., shared mutable state, identity).
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What are property wrappers in Swift?",
        answer: """
        A property wrapper encapsulates reusable logic around a stored property via the @propertyWrapper attribute. It must define a wrappedValue, and optionally a projectedValue (accessed via $).

        Common examples:
        • @State, @Binding, @Published — SwiftUI/Combine state management
        • @AppStorage — UserDefaults binding in SwiftUI
        • @UserDefault — custom wrapper for UserDefaults
        • @Clamped — constrain a value to a range

        The compiler rewrites @Foo var x: T into a backing storage instance of Foo<T> and synthesizes the get/set through wrappedValue. The projectedValue ($x) exposes additional API (e.g., a Binding<T> from @State).
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What are generics in Swift and why are they important?",
        answer: """
        Generics allow writing flexible, reusable code that works with any type satisfying given constraints, without sacrificing type safety or performance.

        Core concepts:
        • Type parameters: func swap<T>(_ a: inout T, _ b: inout T)
        • Where clauses: func max<T: Comparable>(_ a: T, _ b: T) -> T
        • Associated types in protocols: protocol Collection { associatedtype Element }
        • Generic types: struct Stack<Element> { ... }

        Swift uses monomorphization — the compiler generates specialized code per concrete type, giving performance close to hand-written code. This differs from Java/C# which use type erasure.

        Opaque types (some Protocol) and existentials (any Protocol) are related: opaque types preserve the concrete type identity; existentials box the value at runtime cost.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is the difference between 'some Protocol' and 'any Protocol'?",
        answer: """
        some Protocol (opaque return type): the compiler knows the concrete type; callers don't. Preserves type identity, zero overhead, enables associated types. Used when the implementation returns one consistent concrete type.

        any Protocol (existential): boxes any conforming type at runtime. Incurs heap allocation + dynamic dispatch. Necessary when you need heterogeneous collections or the type varies at runtime.

        Example:
        • func makeView() -> some View  — SwiftUI, compiler enforces single concrete type
        • var items: [any Animal]       — array of mixed Animal conformers

        Swift 5.7+ requires explicit any to make the boxing cost visible. Prefer some for return types; use any only when type erasure is genuinely needed.
        """,
        difficulty: .hard,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is protocol composition and when would you use it?",
        answer: """
        Protocol composition combines multiple protocols into a single requirement using &:

            func configure(_ view: UIView & Configurable & Animatable) { }

        The parameter must conform to ALL listed protocols. No new type is created — it's a syntactic constraint.

        Use cases:
        • Expressing precise requirements without creating a new protocol hierarchy
        • Delegate patterns where an object must satisfy multiple interfaces
        • Combining a class requirement with protocol conformances (UIView & Configurable)

        Composition favors narrow interfaces over wide ones — aligns with Interface Segregation Principle.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "Explain Swift's Result type and when to use it over throws.",
        answer: """
        Result<Success, Failure: Error> is an enum with .success(Success) and .failure(Failure) cases. It makes the error type explicit and is value-based (can be stored, passed, transformed).

        Use Result when:
        • Working with async callbacks (pre async/await era) where you can't use throws
        • You want to store or pass a result for later processing
        • The failure type carries meaningful differentiation (typed errors)

        Use throws when:
        • You have synchronous control flow and want cleaner try/catch syntax
        • Combined with async/await (async throws is idiomatic modern Swift)

        Result maps nicely: result.map { ... }.mapError { ... }.flatMap { ... }
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What are associated types in protocols? Give an example.",
        answer: """
        An associated type is a placeholder type within a protocol that conforming types must specify. It creates a family of related types without naming them concretely upfront.

            protocol Container {
                associatedtype Element
                func append(_ item: Element)
                var first: Element? { get }
            }

        Conformers supply the concrete type (explicitly or via inference):

            struct Stack<T>: Container {
                typealias Element = T   // usually inferred
                ...
            }

        This is what makes Swift's Collection, Sequence, etc. so powerful. The constraint machinery (where clauses) lets you write algorithms that work across any conforming type.

        Important: Protocols with associated types can't be used directly as existentials (any Container) without type erasure — hence AnyCollection, etc.
        """,
        difficulty: .hard,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is the @discardableResult attribute?",
        answer: """
        Applied to a function to suppress the "result of call is unused" compiler warning when the caller ignores the return value.

            @discardableResult
            func addItem(_ item: Item) -> Bool { ... }

        Without it, callers must either use the return value or explicitly discard it with _ = addItem(...).

        Use sparingly — the warning exists to catch bugs where callers forget to check results (e.g., a Bool indicating success). Apply @discardableResult only when ignoring the return value is a legitimate and common use case.
        """,
        difficulty: .easy,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is the difference between lazy var and a computed property?",
        answer: """
        Computed property: re-executed every access, no storage. Good for derived values that are cheap to compute.

        lazy var: stored property initialized once on first access, then cached. Ideal for expensive initialization you want to defer until needed.

        Key differences:
        • lazy var is mutable (var required) — calling code can replace the value
        • lazy var is not thread-safe by default — concurrent first access can initialize it twice
        • Computed properties have no backing storage
        • lazy var can reference self because it's evaluated after init completes

        Thread-safety note: if lazy initialization must be thread-safe, use a different pattern (DispatchQueue, actor, etc.).
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
]

// MARK: - Memory Management

let memoryManagementCards: [ConceptCard] = [
    ConceptCard(
        question: "Explain ARC (Automatic Reference Counting) in Swift.",
        answer: """
        ARC automatically manages memory for reference types (classes). It tracks how many strong references point to each object. When the count drops to zero, the object is deallocated.

        Key rules:
        • Strong reference (default): increments retain count
        • ARC inserts retain/release calls at compile time — not at runtime like GC
        • No runtime pauses (unlike garbage collection)

        What ARC doesn't handle:
        • Retain cycles — two objects strongly referencing each other, keeping both alive forever
        • Solution: break cycles with weak or unowned

        For value types (structs/enums), ARC doesn't apply — they're stack-allocated or embedded directly.
        """,
        difficulty: .easy,
        topic: .memoryManagement
    ),
    ConceptCard(
        question: "What is a retain cycle and how do you prevent it?",
        answer: """
        A retain cycle occurs when two or more objects hold strong references to each other, preventing either from ever being deallocated.

        Most common scenarios:
        1. Closure capturing self strongly (self → closure → self)
        2. Delegate pattern with a strong delegate property
        3. Two objects with strong references to each other

        Prevention:
        • Closure capture lists: [weak self] or [unowned self]
        • Delegate properties: weak var delegate: MyDelegate?
        • Use weak in parent→child-like relationships where child doesn't own parent

        Detection:
        • Instruments → Leaks template
        • Xcode memory graph debugger (Debug → Memory Graph)
        • deinit not being called is a telltale sign
        """,
        difficulty: .medium,
        topic: .memoryManagement
    ),
    ConceptCard(
        question: "What is the difference between weak and unowned references?",
        answer: """
        Both break retain cycles by not incrementing the reference count.

        weak:
        • Always Optional — automatically set to nil when the referenced object deallocates
        • Safe to use when the referenced object can legitimately outlive or be nil
        • Example: delegate properties, IBOutlets in some cases

        unowned:
        • Non-optional — assumed to always have a value as long as the referencing object is alive
        • Crashes if accessed after the object deallocates (like force-unwrap)
        • Slightly lower overhead than weak (no nil-ing logic)
        • Use when the reference is guaranteed to live at least as long as self (e.g., a child referencing its parent in a known ownership hierarchy)

        Rule of thumb: default to weak; use unowned only when you're certain about the lifetime.
        """,
        difficulty: .medium,
        topic: .memoryManagement
    ),
    ConceptCard(
        question: "How do you detect a memory leak in an iOS app?",
        answer: """
        1. Xcode Memory Graph Debugger: Debug → Memory Graph (⌃⌥⌘M). Shows live objects with reference edges. Purple exclamation marks flag leaks. Look for objects that should have been deallocated.

        2. Instruments → Leaks: Run the Leaks profiler to see objects that are unreachable but not freed. The call tree shows where allocation originated.

        3. Instruments → Allocations: Track object lifetime, look for objects whose count grows monotonically during use.

        4. deinit logging: Add print("deinit \\(Self.self)") to view controllers and view models — if you push/pop a VC and deinit isn't called, there's a leak.

        5. XCTest + addTeardownBlock: Weak reference to the subject; assert it's nil after test.

        Common sources: closure retain cycles, NotificationCenter observers not removed, delegate strong references, timers.
        """,
        difficulty: .medium,
        topic: .memoryManagement
    ),
]

// MARK: - Concurrency

let concurrencyCards: [ConceptCard] = [
    ConceptCard(
        question: "Explain async/await in Swift and how it differs from completion handlers.",
        answer: """
        async/await lets you write asynchronous code with the visual structure of synchronous code, eliminating "callback hell."

        Completion handler style:
            func fetchUser(id: String, completion: @escaping (Result<User, Error>) -> Void) { ... }

        async/await style:
            func fetchUser(id: String) async throws -> User { ... }
            let user = try await fetchUser(id: "123")

        Key benefits:
        • Structured error handling with try/catch
        • Compiler enforces that await suspends the current task (not a thread block)
        • Easier to reason about sequential and parallel operations
        • Eliminates escaping closure capture list complexity

        Under the hood: await suspends the current task (freeing the thread) and resumes on an appropriate executor when the result is ready.
        """,
        difficulty: .medium,
        topic: .concurrency
    ),
    ConceptCard(
        question: "What is an Actor in Swift and what problem does it solve?",
        answer: """
        An actor is a reference type that protects its mutable state from concurrent access. Only one task at a time can access an actor's state, eliminating data races at the compiler level.

            actor BankAccount {
                private var balance: Double = 0
                func deposit(_ amount: Double) { balance += amount }
            }

        Access to actor-isolated state requires await:
            await account.deposit(100)

        MainActor: a global actor representing the main thread. Mark classes/functions with @MainActor to ensure they run on the main thread. SwiftUI's ObservableObject typically needs @MainActor for @Published property updates.

        Actors vs. locks: Actors are higher-level — no deadlocks from nested lock acquisition, compiler-verified isolation, cooperative scheduling (no blocked threads).
        """,
        difficulty: .medium,
        topic: .concurrency
    ),
    ConceptCard(
        question: "What is Sendable in Swift?",
        answer: """
        Sendable is a protocol (marker protocol — no requirements) that declares a type is safe to send across concurrency boundaries (between tasks/actors) without data races.

        Types that are automatically Sendable:
        • Value types with all Sendable stored properties
        • Actors (protect their own state)
        • Classes marked @unchecked Sendable (you assert thread safety manually)
        • Immutable classes (all let properties that are Sendable)

        Types that are NOT Sendable: classes with mutable state, closures capturing mutable state.

        The compiler checks Sendable conformance at actor boundaries. Passing a non-Sendable value to a different actor produces a warning/error.

        Why it matters: At senior level, Sendable is central to Swift 6's strict concurrency model and eliminating data races at compile time.
        """,
        difficulty: .hard,
        topic: .concurrency
    ),
    ConceptCard(
        question: "Explain Task and TaskGroup in Swift concurrency.",
        answer: """
        Task: a unit of async work. Can be structured (within an async context) or unstructured.
        • Task { } — launches unstructured, inherits actor context
        • Task.detached { } — no inherited context, no actor isolation

        Cancellation propagates automatically through structured concurrency. Always check Task.isCancelled or use try Task.checkCancellation().

        TaskGroup: runs multiple child tasks in parallel and collects results.
            await withTaskGroup(of: Image.self) { group in
                for url in urls {
                    group.addTask { await fetchImage(url) }
                }
                for await image in group { process(image) }
            }

        async let: simpler syntax for a fixed number of parallel tasks:
            async let a = fetchA()
            async let b = fetchB()
            let (resultA, resultB) = await (a, b)
        """,
        difficulty: .medium,
        topic: .concurrency
    ),
    ConceptCard(
        question: "What is GCD (Grand Central Dispatch) and how does it compare to Swift concurrency?",
        answer: """
        GCD is Apple's C-based thread pool abstraction. You dispatch work to queues:
        • DispatchQueue.main — serial, main thread
        • DispatchQueue.global() — concurrent background
        • Custom serial queues — thread-safe access to resources

        Comparison with Swift Concurrency (async/await + actors):
        • Swift concurrency uses a cooperative thread pool — tasks suspend instead of blocking threads, so far fewer threads are needed
        • Actors replace serial queues for state protection with compile-time guarantees
        • async/await eliminates callback nesting
        • Swift concurrency has better cancellation, error propagation, and Sendable checking

        GCD still relevant for: integrating with ObjC/C APIs, DispatchWorkItem cancellation, specific timing (DispatchSourceTimer), legacy codebases.

        Modern practice: prefer Swift concurrency for new code; use GCD when bridging to older APIs.
        """,
        difficulty: .medium,
        topic: .concurrency
    ),
]

// MARK: - SwiftUI

let swiftUICards: [ConceptCard] = [
    ConceptCard(
        question: "What is the difference between @State, @Binding, @StateObject, and @ObservedObject?",
        answer: """
        @State: value-type (struct/enum/primitive) owned by the view. Private source of truth. SwiftUI recreates views but preserves @State storage.

        @Binding: a read-write reference into some other view's @State. The child doesn't own the data — it shares it.

        @StateObject: reference-type (ObservableObject class) owned by the view. Created once and kept alive for the view's lifetime. Use for view-owned view models.

        @ObservedObject: reference-type passed in from outside. The view doesn't own it — don't let it be recreated by a parent, or you'll lose state. Use for injected dependencies.

        @EnvironmentObject: ObservableObject injected into the environment and accessible anywhere in the view hierarchy without explicit passing.

        Rule of thumb: @StateObject when the view creates it; @ObservedObject when it's injected.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "Explain the SwiftUI view update lifecycle.",
        answer: """
        1. State changes: when @State, @Published (via @ObservedObject/@StateObject), or @Environment values change, SwiftUI marks the view as needing an update.

        2. body re-evaluation: SwiftUI calls body on the affected view. This is a pure function — no side effects in body.

        3. Diffing: SwiftUI compares the new view tree with the previous rendering tree and applies only the minimal changes to the actual UIView/CALayer hierarchy.

        4. View identity: views are identified by their position in the tree (structural identity) or explicit id(_:). Changing identity destroys and recreates a view, resetting @State.

        Key insight: SwiftUI views are cheap value types — body is called frequently. Expensive work belongs in ObservableObject, not in body. Use .task{} for async work tied to view lifetime.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "What are ViewModifiers and how do you create a custom one?",
        answer: """
        A ViewModifier transforms a view by wrapping it in a new view with additional behavior or appearance. All .padding(), .foregroundColor(), etc. are ViewModifiers.

        Creating a custom one:
            struct CardStyle: ViewModifier {
                func body(content: Content) -> some View {
                    content
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
            }

            extension View {
                func cardStyle() -> some View {
                    modifier(CardStyle())
                }
            }

        Benefits: reusability, clean call site, can hold @State if needed.

        ViewModifier vs custom View: prefer ViewModifier when the intent is to style/wrap an unknown content view. Use a concrete View when you control the full content.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "How does NavigationStack work in SwiftUI and how does it differ from NavigationView?",
        answer: """
        NavigationStack (iOS 16+) uses a value-based navigation model backed by a path array. It replaces the older NavigationView.

        Key features:
        • NavigationStack(path: $path) — bind to a NavigationPath or typed array to control navigation programmatically
        • .navigationDestination(for: Type.self) — register destinations for value types
        • Deep link support: populate the path array to jump to any depth instantly
        • navigationDestination can live anywhere in the stack's subtree

        Differences from NavigationView:
        • NavigationView was deprecated in iOS 16
        • NavigationView used .navigationViewStyle for split views; now use NavigationSplitView
        • NavigationStack is explicit about the path, making programmatic navigation much cleaner

        For iPad/Mac split views: NavigationSplitView with sidebar/content/detail columns.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "What is @ViewBuilder and when should you use it?",
        answer: """
        @ViewBuilder is a result builder that lets a function return multiple views conditionally, building a single view from a list of view expressions. It's what makes the DSL syntax inside body work.

            @ViewBuilder
            func badge(for user: User) -> some View {
                if user.isPremium {
                    Image(systemName: "star.fill")
                } else {
                    EmptyView()
                }
            }

        Without @ViewBuilder, functions returning views must have a single explicit return and can't use if/switch directly.

        Use it when:
        • Building helper functions that return conditional or composite views
        • Creating container views that accept generic content (like HStack does)

        Note: @ViewBuilder-marked closures support up to 10 view expressions due to the underlying TupleView implementation.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "What is the difference between LazyVStack and VStack?",
        answer: """
        VStack: renders all child views immediately when the container appears, regardless of whether they're visible.

        LazyVStack: renders children on demand as they scroll into view, and may deallocate off-screen views to save memory.

        When to use LazyVStack:
        • Large lists (50+ items) inside a ScrollView where items have significant rendering cost
        • Combined with ScrollView { LazyVStack { ... } } as an alternative to List

        When to prefer VStack:
        • Small, fixed number of views — lazy overhead isn't worth it
        • You need predictable layout measurements (lazy stacks defer measurement)

        For performance: List uses lazy loading automatically. LazyVStack/LazyHStack are for custom ScrollView-based layouts.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "How does @Environment work, and how do you define a custom EnvironmentKey?",
        answer: """
        @Environment reads values propagated down the view hierarchy. SwiftUI ships with built-in keys like colorScheme, locale, dismiss, and horizontalSizeClass.

            struct ContentView: View {
                @Environment(\\.colorScheme) var colorScheme
                @Environment(\\.dismiss) var dismiss
            }

        Defining a custom key:
            private struct AccentColorKey: EnvironmentKey {
                static let defaultValue: Color = .blue
            }

            extension EnvironmentValues {
                var accentTheme: Color {
                    get { self[AccentColorKey.self] }
                    set { self[AccentColorKey.self] = newValue }
                }
            }

            // Inject at any ancestor:
            ContentView().environment(\\.accentTheme, .purple)

            // Read anywhere below:
            @Environment(\\.accentTheme) var accentTheme

        @Environment vs @EnvironmentObject:
        • @Environment is key-path based, value-type safe, has a compile-time default.
        • @EnvironmentObject requires an ObservableObject injected via .environmentObject(_:) and crashes at runtime if missing.
        • Prefer @Environment for simple values/actions; @EnvironmentObject for shared observable state.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "What is the @Observable macro (iOS 17) and how does it differ from ObservableObject?",
        answer: """
        @Observable (Swift 5.9 / iOS 17) is a macro from the Observation framework that replaces the ObservableObject + @Published pattern.

        Old pattern:
            class CounterVM: ObservableObject {
                @Published var count = 0
            }
            @StateObject var vm = CounterVM()

        New pattern:
            @Observable class CounterVM {
                var count = 0   // all stored properties are automatically observed
            }
            @State var vm = CounterVM()   // no longer needs @StateObject

        Key differences:
        • No @Published needed — all stored properties participate in observation automatically.
        • Views only re-render when the specific properties they read change, not whenever any property changes. Fine-grained dependency tracking.
        • Use @State (not @StateObject) for view-owned models; @Bindable for two-way bindings.
        • @Bindable lets you create $bindings from @Observable properties.
        • Pass via environment with .environment(_:) directly — no .environmentObject needed.

        Backward compatibility: ObservableObject still works; @Observable is additive for iOS 17+.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "What are @AppStorage and @SceneStorage, and when do you use each?",
        answer: """
        @AppStorage: a property wrapper that reads/writes a value in UserDefaults and triggers a view update on change. Sugar over UserDefaults with automatic SwiftUI integration.

            @AppStorage("isDarkMode") var isDarkMode = false

        • Backed by UserDefaults (default suite or custom).
        • Persists across app launches.
        • Supports Bool, Int, Double, String, Data, URL.

        @SceneStorage: stores small amounts of UI state per scene (window) and restores it on relaunch or scene reconnection. Backed by the scene restoration mechanism, not UserDefaults.

            @SceneStorage("selectedTab") var selectedTab = 0

        • Scoped to a specific scene — two windows can have different values.
        • Erased when the scene is explicitly closed by the user.
        • Supports same types as @AppStorage.

        When to use which:
        • @AppStorage: user preferences, feature flags, settings that should apply globally across all scenes.
        • @SceneStorage: transient UI state (selected tab, scroll offset, draft text) that should restore per window.
        • Neither should store large/sensitive data — use CoreData/Keychain for that.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "How do PreferenceKey and anchorPreference work in SwiftUI?",
        answer: """
        SwiftUI data flows down the hierarchy (@Environment, parameters). PreferenceKey flows data up — a child reports a value that an ancestor can read.

        Defining a PreferenceKey:
            struct FrameKey: PreferenceKey {
                static var defaultValue: CGRect = .zero
                static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
                    value = nextValue()   // or combine, e.g. value = value.union(nextValue())
                }
            }

        Reporting from a child:
            .background(
                GeometryReader { geo in
                    Color.clear.preference(key: FrameKey.self,
                                           value: geo.frame(in: .global))
                }
            )

        Reading in an ancestor:
            .onPreferenceChange(FrameKey.self) { frame in
                self.childFrame = frame
            }

        anchorPreference: like preference, but uses Anchor<T> values (positions/sizes) in a named coordinate space — safer than raw CGRect because the conversion is deferred to the ancestor.

        Common use cases:
        • Measuring child view sizes to align or resize siblings.
        • Building custom matched-geometry-like animations.
        • Equalizing widths across sibling views.
        """,
        difficulty: .hard,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "How does SwiftUI animation work? Explain implicit vs. explicit animation and withAnimation vs. .animation.",
        answer: """
        SwiftUI animates the difference between two view states. Any Animatable property (position, opacity, color, etc.) interpolates between old and new values.

        Implicit animation (.animation modifier):
            Circle()
                .scaleEffect(isExpanded ? 2 : 1)
                .animation(.spring(), value: isExpanded)
        • Fires whenever `isExpanded` changes, regardless of what triggered the change.
        • The `value:` parameter (iOS 17+) scopes the animation to a specific value — always prefer it to avoid unexpected animations.

        Explicit animation (withAnimation):
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        • Animates all state changes made inside the closure.
        • Gives more control over timing; useful when multiple state changes should animate together.

        Transitions (.transition): animate a view entering or leaving the hierarchy:
            if isVisible {
                Banner().transition(.slide)
            }

        Custom animations: conform to the Animatable protocol by providing animatableData (a VectorArithmetic value).

        matchedGeometryEffect: animates a view's frame between two positions in different parts of the hierarchy using a shared namespace.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
    ConceptCard(
        question: "What is GeometryReader and what are its trade-offs?",
        answer: """
        GeometryReader is a container view that exposes the size and coordinate-space information of its parent to its children via a GeometryProxy.

            GeometryReader { geo in
                Circle()
                    .frame(width: geo.size.width * 0.5)
            }

        GeometryProxy provides:
        • geo.size — the available width/height
        • geo.frame(in:) — the frame in a named or global coordinate space
        • geo.safeAreaInsets

        Trade-offs:
        • GeometryReader fills all available space by default (greedy layout). This can break layouts if used carelessly inside stacks.
        • body is called on every size change — keep it cheap or extract to a subview.
        • For just reading a child's size, prefer the .onGeometryChange modifier (iOS 17) or PreferenceKey + background trick, which are less disruptive to layout.
        • .onGeometryChange(for:of:action:) is the modern replacement for many GeometryReader patterns.

        Common uses: proportional sizing, parallax effects, anchoring overlays, reading safe area insets in unusual contexts.
        """,
        difficulty: .medium,
        topic: .swiftUI
    ),
]

// MARK: - UIKit

let uiKitCards: [ConceptCard] = [
    ConceptCard(
        question: "Describe the UIViewController lifecycle.",
        answer: """
        In order:
        1. init / loadView — create/load the view hierarchy
        2. viewDidLoad — view hierarchy loaded; one-time setup (add subviews, configure)
        3. viewWillAppear — about to become visible (repeated); layout not final yet
        4. viewWillLayoutSubviews / viewDidLayoutSubviews — layout pass happening
        5. viewDidAppear — now on screen; start animations, timers, tracking
        6. viewWillDisappear — about to leave screen; pause work
        7. viewDidDisappear — off screen; remove observers, stop heavy resources
        8. deinit — object deallocating

        Common interview mistake: doing layout work in viewDidLoad when bounds aren't final. Use viewDidLayoutSubviews or Auto Layout constraints instead.

        viewWillAppear/viewDidAppear are called every time the VC appears — distinguish from one-time vs. repeated setup.
        """,
        difficulty: .easy,
        topic: .uiKit
    ),
    ConceptCard(
        question: "What is the difference between frame and bounds in UIView?",
        answer: """
        frame: the view's position and size in its superview's coordinate system. Moving a view changes its frame.

        bounds: the view's own internal coordinate system. Origin is usually (0,0). Changing bounds.origin scrolls the view's content (this is how UIScrollView works).

        size: frame.size and bounds.size are equal unless the view is rotated/transformed — after a transform, frame reflects the bounding box of the rotated view; bounds still reflects the un-transformed size.

        Common pitfall: reading frame after applying a transform gives unexpected results. Read bounds for the true content size.

        center: the midpoint of the frame in superview coordinates. Moving a view without transform: set center or frame.origin.
        """,
        difficulty: .medium,
        topic: .uiKit
    ),
    ConceptCard(
        question: "What is the UIKit responder chain?",
        answer: """
        The responder chain is a linked list of UIResponder objects (UIView, UIViewController, UIWindow, UIApplication, AppDelegate) that events travel up until handled.

        Flow for a touch event:
        1. Hit testing finds the frontmost view at the touch point
        2. That view becomes first responder
        3. If it doesn't handle the event, it passes up: view → superview → VC → VC's view → window → app

        Use cases:
        • First responder: managing keyboard (becomeFirstResponder, resignFirstResponder)
        • Custom actions: sending UIAction through the chain with UIApplication.shared.sendAction
        • Gesture recognizers intercept touches before the responder chain

        Senior tip: Can be used to pass events/actions from deep in the hierarchy to a distant ancestor without coupling.
        """,
        difficulty: .medium,
        topic: .uiKit
    ),
    ConceptCard(
        question: "How does UITableView/UICollectionView cell reuse work? What is diffable data source?",
        answer: """
        Cell reuse: cells scrolled off screen are placed in a reuse pool keyed by identifier. dequeueReusableCell(withIdentifier:for:) returns a recycled cell (or creates one if the pool is empty), avoiding the cost of allocating and laying out new cells on every scroll frame.

        Correct usage pattern:
        • Always call dequeueReusableCell — never create cells manually in cellForRow
        • Reset all state in the cell's prepareForReuse() — cells carry state from their previous use
        • Register cell classes or nibs before use: tableView.register(MyCell.self, forCellReuseIdentifier: "cell")

        Diffable Data Source (iOS 13+):
        • Replaces the old delegate data source methods with a snapshot-based API
        • NSDiffableDataSourceSnapshot describes the full state (sections + items) at a point in time
        • apply(_:animatingDifferences:) diffs the snapshot automatically — no more manual insertRows/deleteRows
        • Items must be Hashable; sections must be Hashable
        • Eliminates "invalid number of rows" crashes from mismatched updates

        When to still use the old delegate: very large dynamic lists where you control diffing manually, or when targeting iOS 12.
        """,
        difficulty: .medium,
        topic: .uiKit
    ),
    ConceptCard(
        question: "What is Auto Layout and how does the constraint system work?",
        answer: """
        Auto Layout is a constraint-based layout system. Instead of setting frames directly, you declare relationships between view attributes (leading, trailing, top, bottom, width, height, centerX, centerY, baseline).

        The engine (Cassowary algorithm) solves the constraint system to produce concrete frames at layout time.

        Constraint priorities (1–1000):
        • Required (1000): must be satisfied or layout breaks
        • High (750): default content hugging / compression resistance
        • Low (250): used for "nice to have" constraints

        Content Hugging Priority: resistance to growing larger than intrinsicContentSize
        Compression Resistance Priority: resistance to shrinking smaller than intrinsicContentSize

        Common pitfalls:
        • Conflicting required constraints → unsatisfiable layout, runtime warnings
        • Missing constraints (under-constrained) → ambiguous layout
        • Modifying constraints in viewDidLoad before the layout pass — use updateConstraints or layoutIfNeeded

        Performance: overly complex constraint graphs (100s of constraints) can slow layout. Prefer fewer, well-chosen constraints. NSLayoutAnchor API is cleaner and safer than NSLayoutConstraint directly.
        """,
        difficulty: .medium,
        topic: .uiKit
    ),
    ConceptCard(
        question: "How do UIView animations work? What is the difference between UIView.animate and Core Animation?",
        answer: """
        UIView.animate is a high-level API that animates animatable properties (frame, alpha, backgroundColor, transform) by:
        1. Snapshotting the initial state
        2. Applying the final state immediately to the model layer
        3. Adding a CAAnimation to interpolate the presentation layer over the duration

            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 0
            }, completion: { _ in view.removeFromSuperview() })

        Core Animation (CAAnimation):
        • Lower level — you manipulate CALayer properties directly
        • Runs on a separate render server process — doesn't block the main thread
        • Presentation layer: the layer's in-flight animated state; model layer: the true final state
        • Enables more control: keyframe paths, timing functions, grouping, fill modes

        UIViewPropertyAnimator (iOS 10+):
        • Interruptible, scrubbable animations
        • Can pause, reverse, or change target mid-flight
        • Useful for gesture-driven transitions (pan to dismiss)

        Key rule: Core Animation operates on copies of layer state — reading back a property mid-animation gives you the model value, not the visible position. Read .presentation()?.position for the in-flight value.
        """,
        difficulty: .medium,
        topic: .uiKit
    ),
]

// MARK: - Networking

let networkingCards: [ConceptCard] = [
    ConceptCard(
        question: "Explain URLSession and its different task types.",
        answer: """
        URLSession is the foundation of networking in iOS. The shared singleton works for basic requests; custom sessions offer configuration (timeouts, caching, auth).

        Task types:
        • URLSessionDataTask — request/response in memory; most common for API calls
        • URLSessionDownloadTask — writes response to a temp file; resumable downloads
        • URLSessionUploadTask — uploads a file/data body; better progress tracking than dataTask
        • URLSessionStreamTask — TCP/IP streaming
        • URLSessionWebSocketTask — WebSocket protocol

        Modern async/await API:
            let (data, response) = try await URLSession.shared.data(for: request)

        Configuration: URLSessionConfiguration.default / .ephemeral (no cache/cookies) / .background (out-of-process downloads/uploads that survive app termination).
        """,
        difficulty: .easy,
        topic: .networking
    ),
    ConceptCard(
        question: "What is Codable and how do you handle custom decoding?",
        answer: """
        Codable = Encodable & Decodable. Provides automatic JSON ↔ Swift type mapping via synthesized implementations.

        Custom decoding with CodingKeys enum:
            struct User: Codable {
                let firstName: String
                enum CodingKeys: String, CodingKey {
                    case firstName = "first_name"
                }
            }

        Custom init(from:) for complex cases: nested containers, different key strategies, type coercion.

        Key decoder settings:
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601

        Error handling: DecodingError.keyNotFound, .typeMismatch, .valueNotFound — always handle these to surface API contract violations.

        Performance: Codable has overhead from reflection-like mechanisms. For very high-throughput parsing consider manual init(from:) or alternatives like Swift's binary formats.
        """,
        difficulty: .medium,
        topic: .networking
    ),
    ConceptCard(
        question: "What is certificate pinning and when should you use it?",
        answer: """
        Certificate pinning validates that the server's certificate (or its public key) matches a known-good value embedded in the app, defeating MITM attacks even from a trusted CA.

        Implementation in iOS:
        • URLSession delegate: urlSession(_:didReceive:completionHandler:) — inspect the server trust, extract the certificate, compare against bundled data
        • TrustKit or Network.framework's sec_protocol_options_set_tls_server_name_override are common alternatives

        Two pinning strategies:
        • Certificate pinning: pin the full certificate. Simple but breaks when the cert rotates.
        • Public key pinning: pin only the public key (SubjectPublicKeyInfo). Survives certificate renewal as long as the key pair stays the same — preferred.

        Tradeoffs:
        • Pros: strong protection against MITM, rogue CAs, network interception proxies
        • Cons: requires a certificate rotation strategy; misconfiguration bricks your networking; complicates testing (proxies like Charles require disabling the pin or using a test build)

        When to use: fintech, healthcare, apps handling sensitive credentials or high-value transactions. Not necessary for low-risk content apps.
        """,
        difficulty: .hard,
        topic: .networking
    ),
    ConceptCard(
        question: "How do you handle pagination when consuming a REST API?",
        answer: """
        Common pagination strategies from APIs:

        1. Offset/limit: ?page=2&per_page=20. Simple but has gaps/duplicates if items are inserted mid-scroll.
        2. Cursor-based: ?after=cursor_token. Server returns an opaque cursor pointing to the next page. More stable for real-time feeds.
        3. Link headers: response headers include a rel="next" URL (GitHub API style).

        iOS implementation patterns:
        • Track isLoading and currentPage/cursor in the ViewModel to avoid duplicate requests
        • Trigger next page fetch when the user scrolls near the bottom (prefetchRowsAt in UITableView, or onAppear on the last item in SwiftUI)
        • Handle the end-of-list state (no next cursor/empty page) to stop fetching
        • Append new results to an existing array; don't replace — prevents scroll position jumping

        async/await pattern:
            func loadNextPage() async {
                guard !isLoading, hasMorePages else { return }
                isLoading = true
                defer { isLoading = false }
                let page = try await api.fetch(cursor: nextCursor)
                items += page.results
                nextCursor = page.nextCursor
                hasMorePages = nextCursor != nil
            }
        """,
        difficulty: .medium,
        topic: .networking
    ),
]

// MARK: - Architecture

let architectureCards: [ConceptCard] = [
    ConceptCard(
        question: "What are the weaknesses of MVC in iOS and how does MVVM address them?",
        answer: """
        MVC weaknesses:
        • "Massive View Controller" — UIViewController ends up handling networking, parsing, business logic, formatting, and UI updates
        • View and model are separated, but VC couples them tightly
        • Hard to unit test: VCs have UIKit dependencies and view lifecycle methods
        • Reusing logic across VCs requires inheritance or copy-paste

        MVVM improvements:
        • ViewModel owns business logic and state transformation — no UIKit imports, fully unit testable
        • View (UIViewController or SwiftUI View) just binds to the VM and forwards actions
        • Clear separation: Model ← ViewModel → View
        • In SwiftUI, @ObservableObject VMs are a natural fit

        Tradeoffs: MVVM adds indirection; binding boilerplate (especially UIKit). For trivial screens, plain MVC may be fine. Senior engineers should be able to discuss when the overhead is worth it.
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    ConceptCard(
        question: "What is the Coordinator pattern in iOS?",
        answer: """
        Coordinators extract navigation logic from view controllers. Each coordinator manages a flow (onboarding, checkout, profile) and owns the VCs within it.

        Basic structure:
            protocol Coordinator: AnyObject {
                var childCoordinators: [Coordinator] { get set }
                func start()
            }

        Benefits:
        • VCs don't know about each other — coordinator creates and presents them
        • Deep link support: a coordinator can reconstruct a navigation state
        • Flows are reusable and independently testable
        • Parent coordinators can orchestrate child coordinators for sub-flows

        Tradeoffs:
        • Boilerplate for simple apps
        • In SwiftUI, NavigationStack's value-based routing is often a better fit
        • Need to carefully manage coordinator lifecycle (strong/weak references)

        Senior tip: worth discussing how you'd adapt Coordinator to SwiftUI (environment injection, navigation path).
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    ConceptCard(
        question: "What is dependency injection and why does it matter?",
        answer: """
        DI is the practice of providing dependencies to an object from the outside rather than having it create them internally.

        Types:
        • Initializer injection (preferred): dependencies passed in init — makes them explicit and testable
        • Property injection: var dependency = ... — flexible but allows invalid state
        • Method injection: pass dependency only where needed

        Why it matters:
        • Testability: inject mock/stub implementations in tests
        • Flexibility: swap implementations (dev/prod, A/B variants) without changing callers
        • Explicitness: dependencies are part of the public API of a type

        DI containers (Swinject, Needle, Factory): automate wiring for large apps. For smaller apps, manual DI (passing dependencies through constructors) is often clearer.

        Anti-pattern to avoid: service locator (global registry) — hides dependencies and makes testing harder.
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    ConceptCard(
        question: "Explain the SOLID principles with iOS/Swift examples.",
        answer: """
        S — Single Responsibility: a type should have one reason to change. A ViewController shouldn't also parse JSON; a NetworkClient shouldn't also cache.

        O — Open/Closed: open for extension, closed for modification. Add behavior via protocol conformance or subclassing rather than editing existing code. Example: new payment methods via a PaymentMethod protocol rather than adding switch cases.

        L — Liskov Substitution: subtypes must be substitutable for their base types without altering correctness. In Swift: protocol conformances must truly satisfy the contract, not just compile.

        I — Interface Segregation: prefer narrow, role-specific protocols over wide ones.
            protocol Readable { func read() -> Data }
            protocol Writable { func write(_ data: Data) }
        A read-only cache conforms to Readable only, not a bloated StorageProtocol.

        D — Dependency Inversion: depend on abstractions, not concrete types.
            class ProfileViewModel {
                let service: UserServiceProtocol  // not URLSession directly
            }
        This is the foundation of testability — swap in a mock UserServiceProtocol in tests.

        Senior tip: SOLID principles are a means to an end (maintainable, testable code), not rules to follow rigidly. In very simple iOS screens, strict adherence adds ceremony with no payoff.
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    ConceptCard(
        question: "What is unidirectional data flow? How does TCA (The Composable Architecture) implement it?",
        answer: """
        Unidirectional data flow: state flows in one direction. Views dispatch actions → a reducer transforms state → views re-render from the new state. No two-way bindings, no hidden state mutations.

        TCA structure:
        • State: a struct holding all feature state
        • Action: an enum of every event that can occur (user taps, network responses, timers)
        • Reducer: a pure function (State, Action) → (State, Effect). Returns the new state and any side effects (async work, navigation)
        • Effect: async work that eventually yields more Actions
        • Store: the runtime — holds state, processes actions through the reducer

        Benefits:
        • Exhaustive testability: feed actions into a TestStore, assert state transforms precisely
        • Composability: combine child features into parent features by pulling back reducers
        • Debuggability: every state change is traceable to a single action

        Tradeoffs:
        • Steep learning curve; significant boilerplate for simple screens
        • Overkill for CRUD apps with minimal cross-feature state sharing
        • Alternatives: simple @Observable ViewModels for most SwiftUI apps; TCA shines in large teams with complex state interactions

        Redux, Flux, and The Elm Architecture share the same unidirectional principle.
        """,
        difficulty: .hard,
        topic: .architecture
    ),
]

// MARK: - Testing

let testingCards: [ConceptCard] = [
    ConceptCard(
        question: "What is the difference between unit tests, integration tests, and UI tests in iOS?",
        answer: """
        Unit tests: test a single function/class in isolation with all dependencies mocked/stubbed. Fast, deterministic. XCTest target without app host.

        Integration tests: test multiple real components working together (e.g., ViewModel + real network layer + parsing). Slower, may require fixtures.

        UI tests (XCUITest): launch the full app and simulate user interactions. Slowest and most brittle, but validate end-to-end flows. Run in a separate process.

        Testing pyramid: many unit tests, fewer integration, minimal UI tests.

        XCTest specifics:
        • XCTestCase subclass with test* methods
        • setUp/setUpWithError runs before each test; tearDown after
        • Async tests: async test methods with await, or XCTestExpectation for callbacks
        • Performance: measure { } block for XCTMetric comparisons
        """,
        difficulty: .easy,
        topic: .testing
    ),
    ConceptCard(
        question: "How do you test asynchronous code in Swift?",
        answer: """
        Modern approach (async/await):
            func testFetchUser() async throws {
                let user = try await sut.fetchUser(id: "1")
                XCTAssertEqual(user.name, "Alice")
            }
        XCTest supports async test functions natively since Xcode 13.

        Legacy approach (XCTestExpectation):
            func testFetchUser() {
                let exp = expectation(description: "fetch")
                sut.fetchUser(id: "1") { user in
                    XCTAssertNotNil(user)
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 2)
            }

        Combine testing:
            var cancellables = Set<AnyCancellable>()
            // Use XCTestExpectation + sink, or the Swift Testing .confirmation pattern

        Key practice: use a mock/stub URLSession (URLProtocol subclass or protocol-abstracted session) to avoid real network calls in unit tests.
        """,
        difficulty: .medium,
        topic: .testing
    ),
    ConceptCard(
        question: "How do you mock dependencies in Swift tests? What are the trade-offs of different approaches?",
        answer: """
        Protocol-based mocking (most common in Swift):
        Define a protocol for the dependency, inject it, then create a mock conformance in tests.

            protocol UserServiceProtocol {
                func fetchUser(id: String) async throws -> User
            }
            class MockUserService: UserServiceProtocol {
                var stubbedUser: User?
                var fetchCallCount = 0
                func fetchUser(id: String) async throws -> User {
                    fetchCallCount += 1
                    return stubbedUser!
                }
            }

        Advantages: no third-party library, explicit, type-safe.
        Disadvantage: protocol must exist even if just for testing; can proliferate boilerplate.

        URLProtocol subclass: intercept URLSession requests without changing production code at all. Great for integration-level network tests.

        @testable import: exposes internal types to tests without making them public. Use for testing internal logic without adding protocols just for testability.

        Libraries: Mockingbird (generates mocks at build time), swift-mock — reduce boilerplate but add build complexity.

        What interviewers listen for: injecting dependencies via init (not singletons), asserting both return values AND side effects (call counts, passed arguments), and keeping tests isolated.
        """,
        difficulty: .medium,
        topic: .testing
    ),
    ConceptCard(
        question: "What is snapshot testing and when is it useful?",
        answer: """
        Snapshot testing renders a view (or any value) to a reference artifact (image, string, JSON) and fails if the output changes. The first run records the snapshot; subsequent runs compare against it.

        Libraries: swift-snapshot-testing (pointfree), iOSSnapshotTestCase (Uber/FB).

        How it works for views:
        1. Render a UIView or SwiftUI view to an image using the snapshot library
        2. On first run: save the image as a reference PNG in the test bundle
        3. On future runs: compare pixel-by-pixel (or perceptually) against the reference

        Good use cases:
        • Preventing unintended visual regressions in design-system components
        • Verifying layout across different Dynamic Type sizes, dark/light mode, locales
        • Documenting the visual contract of reusable components

        Tradeoffs:
        • Snapshots are fragile to rendering environment changes (OS update, font changes, anti-aliasing) — can produce false failures
        • Must be regenerated intentionally when designs change
        • Large binary files in source control unless stored externally
        • Slow compared to pure unit tests

        Best practice: use for leaf UI components with stable designs; not for every screen. Pair with unit tests for logic and behavior.
        """,
        difficulty: .medium,
        topic: .testing
    ),
]

// MARK: - Performance

let performanceCards: [ConceptCard] = [
    ConceptCard(
        question: "What causes dropped frames (jank) in iOS apps?",
        answer: """
        iOS targets 60fps (16ms/frame) or 120fps on ProMotion displays (8ms). A dropped frame means the main thread couldn't complete its work in time.

        Common causes:
        • Heavy work on the main thread: synchronous networking, large JSON parsing, image decoding
        • Over-drawing: too many transparent/blurred layers composited together
        • Expensive Auto Layout passes: large numbers of constraints, unnecessary invalidation
        • Image decompression on main thread: UIImage(named:) decodes lazily on first draw
        • Cell dequeue misuse: creating new cells instead of reusing, heavy setup in cellForRow
        • Core Data fetch on main thread

        Detection:
        • Xcode Instruments → Time Profiler: see what's running on main thread
        • Instruments → Core Animation: see GPU vs CPU rendering, offscreen passes

        Fixes: background threads for data work, async image decoding, prefetching, reducing layer complexity.
        """,
        difficulty: .medium,
        topic: .performance
    ),
    ConceptCard(
        question: "How do you use Instruments to profile an iOS app?",
        answer: """
        Key Instruments templates:
        • Time Profiler: CPU usage by thread/call tree. Find main-thread bottlenecks.
        • Allocations: object creation over time. Find memory growth and allocation spikes.
        • Leaks: unreachable but allocated objects. Find retain cycles.
        • Core Animation (Rendering): frame rate, offscreen rendering, blended layers.
        • Network: URLSession requests, timing, sizes.
        • Energy Log: CPU wake, location, network usage — battery impact.

        Workflow:
        1. Profile on a real device (simulator results are unreliable for performance)
        2. Use a Release or profile build (not Debug — optimizer changes behavior)
        3. Reproduce the scenario, then analyze the hottest call stacks
        4. Focus on the lowest-hanging fruit: what's consuming the most time?

        Senior tip: know how to read the heavy call tree vs. time tree views and filter to your own code.
        """,
        difficulty: .medium,
        topic: .performance
    ),
    ConceptCard(
        question: "How do you optimize app launch time?",
        answer: """
        Launch phases:
        1. Pre-main: dylib loading, Objective-C class registration, Swift initializers. Measured with DYLD_PRINT_STATISTICS.
        2. application(_:didFinishLaunchingWithOptions:): your code. Measured with MetricKit or Instruments → App Launch.
        3. First meaningful frame: initial view hierarchy rendered.

        Pre-main optimizations:
        • Reduce dynamic framework count — each dylib adds ~1–5ms
        • Eliminate unnecessary static initializers (+load, global Swift stored properties with non-trivial initializers)
        • Use lazy initialization for anything not needed at first frame

        didFinishLaunching optimizations:
        • Defer non-critical setup (analytics, push registration, feature flags) off the main thread or after first frame
        • Lazy-initialize services on first use rather than eagerly in app delegate
        • Avoid synchronous disk/network I/O on main thread during launch

        Measurement tools:
        • Instruments → App Launch template: flame chart from process start to first frame
        • MetricKit / Xcode Organizer → Launch Time: real-user p50/p90 launch times from production

        Target: < 400ms to first meaningful frame (Apple's guideline for avoiding the watchdog timer on launch).
        """,
        difficulty: .medium,
        topic: .performance
    ),
]

// MARK: - Swift Fundamentals (additional)

extension Array where Element == ConceptCard {
    // intentionally empty — used as a namespace anchor
}

let swiftFundamentalsAdditionalCards: [ConceptCard] = [
    ConceptCard(
        question: "What are Swift's access control levels and when do you use each?",
        answer: """
        Swift has five access levels, from most to least restrictive:

        • private — accessible only within the enclosing declaration and its extensions in the same file
        • fileprivate — accessible anywhere in the same source file
        • internal (default) — accessible within the same module (app or framework target)
        • public — accessible from any module, but subclassing/overriding is restricted to the defining module
        • open — accessible and subclassable/overridable from any module

        Key distinctions:
        • open vs public: public classes cannot be subclassed outside the module; open ones can. Use public for most APIs; open only when you explicitly intend external subclassing.
        • private vs fileprivate: prefer private by default. Use fileprivate when extensions in the same file need access.

        Practical rules:
        • Default to the most restrictive level that works
        • Framework authors: mark public API as public/open explicitly; everything else stays internal
        • @testable import makes internal declarations visible to test targets

        Common interview trap: "What's the difference between public and open?" — open allows external subclassing; public does not.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What are enumerations with associated values in Swift? How do they compare to tagged unions?",
        answer: """
        Swift enums can attach values of any type to each case, making them algebraic sum types (tagged unions):

            enum NetworkError: Error {
                case badStatusCode(Int)
                case decodingFailed(DecodingError)
                case offline
            }

            enum Shape {
                case circle(radius: Double)
                case rectangle(width: Double, height: Double)
                case point
            }

        Extracting values via pattern matching:
            switch error {
            case .badStatusCode(let code): print("HTTP \\(code)")
            case .decodingFailed(let e):   print(e)
            case .offline:                 break
            }

        if case / guard case for single-case matching:
            if case .circle(let r) = shape { ... }

        Raw values vs associated values:
        • Raw values: all cases share the same primitive type (String, Int); set at compile time
        • Associated values: each case can carry different types; set at runtime

        Why this matters: enums with associated values model domain state precisely — impossible states become unrepresentable. Classic example: Result<Success, Failure>, Optional<T>.

        Indirect enums: for recursive types (linked lists, trees), mark cases or the whole enum indirect to allow heap allocation.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is the guard statement and why is it preferred over nested if-let?",
        answer: """
        guard evaluates a condition and exits the current scope (return, throw, break, continue) if the condition is false. Bindings introduced by guard let are available for the rest of the enclosing scope — the opposite of if let.

            func process(user: User?) throws {
                guard let user = user else { throw AppError.notLoggedIn }
                guard user.isActive else { return }
                // user is non-optional here and for the rest of the function
                render(user)
            }

        Why prefer guard over nested if let:
        • Avoids "pyramid of doom" — each guard exits early, keeping the happy path at the top level
        • Bindings are in scope after the guard, so you don't nest inside braces
        • Communicates intent: "this must be true to continue"

        guard vs if let:
        • Use guard when a nil/false value means you can't proceed — early exit
        • Use if let when nil is a valid branch you want to handle inline

        guard with multiple conditions:
            guard let name = user.name, !name.isEmpty, name.count < 100 else { return }
        All bindings are available after the guard if all conditions pass.
        """,
        difficulty: .easy,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "How does error handling work in Swift? Explain do/try/catch, defer, and rethrows.",
        answer: """
        Swift uses typed, synchronous error propagation via throws:

            func fetchData(from url: URL) throws -> Data {
                guard url.scheme == "https" else { throw NetworkError.insecureURL }
                return try Data(contentsOf: url)
            }

        do/try/catch:
            do {
                let data = try fetchData(from: url)
                process(data)
            } catch NetworkError.insecureURL {
                // specific case
            } catch {
                // catch-all; error is bound to `error`
            }

        try variants:
        • try — propagates the error; must be inside a throws function or do/catch
        • try? — converts to Optional; nil on failure, no error info
        • try! — force-unwrap; crashes on error; avoid except in guaranteed contexts

        defer: executes a block when the current scope exits, regardless of how (normal return, throw, break). Useful for cleanup:
            func open() throws {
                let file = try openFile()
                defer { file.close() }   // always called
                try process(file)
            }
        Multiple defers execute in LIFO order.

        rethrows: a function that takes a throwing closure and only throws if the closure throws. Lets callers use try or not based on whether they pass a throwing closure:
            func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]

        Error types: conform to the Error protocol. Swift 5.7+ typed throws (throws(MyError)) are available for precise error types without boxing overhead.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What are property observers (willSet / didSet) and when should you use them?",
        answer: """
        Property observers let you run code in response to a stored property changing value.

            var score: Int = 0 {
                willSet { print("About to change to \\(newValue)") }
                didSet  { print("Changed from \\(oldValue)") }
            }

        • willSet: called before the value changes; newValue is the incoming value
        • didSet: called after the value changes; oldValue is the previous value
        • Not called during initialization

        Common use cases:
        • Syncing UI when a model property changes (pre-Combine/SwiftUI era)
        • Clamping or validating values after assignment
        • Triggering side effects (logging, saving) on change

            var username: String = "" {
                didSet { validate(); save() }
            }

        Tradeoffs vs @Published / Combine:
        • Property observers are synchronous and tightly coupled to the type — fine for simple cases
        • @Published + Combine or @Observable provide reactive pipelines with operators (debounce, map, etc.) — prefer for UI binding

        Important: if you pass a property with a didSet to an inout parameter, didSet fires after the function returns (copy-in/copy-out semantics).
        """,
        difficulty: .easy,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "Explain copy-on-write (COW) in Swift. How does it work and which types use it?",
        answer: """
        Copy-on-write is an optimization where value types defer the actual memory copy until a mutation occurs. If a copy is made but never mutated, both variables share the same underlying buffer.

        How it works:
        1. On assignment, both variables point to the same heap buffer (no copy yet)
        2. On mutation, Swift checks the reference count of the buffer
        3. If refcount == 1 (only one owner): mutate in place — no copy
        4. If refcount > 1 (shared): copy the buffer first, then mutate

        Standard library types with COW: Array, Dictionary, Set, String, Data.

        Custom COW — you must implement it yourself for custom value types wrapping a class:
            struct MyBuffer {
                private var storage: Storage  // class, heap-allocated
                mutating func mutate() {
                    if !isKnownUniquelyReferenced(&storage) {
                        storage = Storage(copying: storage)
                    }
                    storage.modify()
                }
            }

        Why it matters: large collections can be passed around freely without hidden O(n) copies. Mutation is still O(n) when a copy is needed, but reads and non-mutating passes are O(1).

        Interview trap: "Are Swift value types always stack-allocated?" — No. Large value types and COW types have their data on the heap; the "value" is just the inline struct (which may be tiny).
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is the difference between Any and AnyObject in Swift?",
        answer: """
        Any: can represent an instance of any type — class, struct, enum, function, Optional, or even another Any.

        AnyObject: can represent an instance of any class type only (reference types). It's the Swift equivalent of Objective-C's id.

            var mixed: [Any] = [1, "hello", true, { }]
            var objects: [AnyObject] = [UIView(), NSString()]

        When are they used?
        • Any: heterogeneous collections, bridging to untyped APIs, JSON parsing intermediates
        • AnyObject: ObjC interop, class-only protocol constraints (protocol P: AnyObject)

        Downcasting from Any:
            if let str = value as? String { ... }

        Pitfall — Optionals in Any:
            let x: Int? = nil
            let y: Any = x          // y is Any wrapping Optional<Int>.none
            print(y)                // prints "nil" but y itself is not nil!
        The compiler warns: "expression implicitly coerced from 'Int?' to 'Any'".

        AnyObject and class-only protocols:
        • Marking a protocol : AnyObject restricts conformance to classes, enabling weak references to protocol-typed values.
        • @objc protocols implicitly require AnyObject.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is @autoclosure and when would you use it?",
        answer: """
        @autoclosure automatically wraps an expression passed as an argument into a zero-argument closure, deferring its evaluation until the closure is called.

        Without @autoclosure:
            func logIfEnabled(_ message: () -> String) {
                if loggingEnabled { print(message()) }
            }
            logIfEnabled({ "Expensive: \\(compute())" })  // must wrap in closure

        With @autoclosure:
            func logIfEnabled(_ message: @autoclosure () -> String) {
                if loggingEnabled { print(message()) }
            }
            logIfEnabled("Expensive: \\(compute())")  // looks like a value, evaluated lazily

        Real-world uses:
        • assert(_:_:): the message argument is @autoclosure so string interpolation only runs if assertions are enabled
        • ?? nil coalescing: the right-hand default value is @autoclosure to avoid evaluating it when the left side is non-nil
        • Lazy logging frameworks

        Combining with @escaping:
            func store(_ value: @autoclosure @escaping () -> Int) { ... }
        The closure can then be stored and called later.

        Caution: @autoclosure hides the fact that an argument is captured as a closure, which can surprise callers expecting eager evaluation. Use sparingly and document the deferred evaluation clearly.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "How does @available work and how do you handle backward compatibility?",
        answer: """
        @available marks declarations as available only on certain platform versions, producing compiler errors or warnings when used outside those bounds.

        Restricting a declaration:
            @available(iOS 16, *)
            func useNavigationStack() { ... }

        Conditionally executing code with #available:
            if #available(iOS 16, *) {
                useNavigationStack()
            } else {
                useLegacyNavigation()
            }

        Or with guard:
            guard #available(iOS 16, *) else { return }

        Deprecation and renaming:
            @available(iOS, deprecated: 15, renamed: "newMethod()")
            func oldMethod() { }

        Marking as unavailable:
            @available(*, unavailable, message: "Use async variant instead")
            func syncFetch() { }

        Deployment target vs availability:
        • Deployment target: the minimum OS your app supports — set in project settings
        • Any API newer than the deployment target requires an #available guard at call sites
        • Xcode flags missing guards as errors

        Best practices:
        • Use #available + fallback rather than raising the deployment target if the feature is non-essential
        • Extract platform-specific code into dedicated functions annotated with @available to keep call sites clean
        • @backDeployed(before:) (Swift 5.8+) lets you ship implementations for older OS versions from your own framework
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is KVO (Key-Value Observing) and when is it still relevant?",
        answer: """
        KVO is an Objective-C-derived mechanism for observing changes to object properties without subclassing or modifying the observed class. The runtime patches the class to call observation callbacks on property changes.

        Modern Swift KVO:
            class Tracker: NSObject {
                @objc dynamic var speed: Double = 0
            }

            let tracker = Tracker()
            let observation = tracker.observe(\\.speed, options: [.old, .new]) { obj, change in
                print("speed: \\(change.newValue!)")
            }
            // observation token keeps subscription alive; cancel by storing nil

        Requirements:
        • The observed class must inherit from NSObject
        • The property must be marked @objc dynamic

        When KVO is still relevant:
        • Observing system/framework properties you don't own (AVPlayer.status, WKWebView.estimatedProgress, SCNNode.transform)
        • Bridging with Objective-C code that already uses KVO
        • CALayer and Core Animation properties

        Prefer Combine / @Observable for new Swift code. KVO is mainly for cases where you can't change the observed class.

        KVC (Key-Value Coding): accessing properties by string key path (object.value(forKey: "name")). Needed for predicate-based Core Data fetches and some ObjC APIs. Type-unsafe — avoid in pure Swift code.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
    ConceptCard(
        question: "What is NotificationCenter and what are its pitfalls?",
        answer: """
        NotificationCenter is a broadcast mechanism: objects post named notifications; observers registered for that name receive them. Decouples sender from receiver — they don't need references to each other.

        Posting:
            NotificationCenter.default.post(name: .dataRefreshed, object: self, userInfo: ["count": 42])

        Observing (block-based, preferred):
            let token = NotificationCenter.default.addObserver(
                forName: .dataRefreshed, object: nil, queue: .main
            ) { notification in
                // handle
            }
            // store `token` and remove when done:
            NotificationCenter.default.removeObserver(token)

        Observing (selector-based, ObjC style):
            NotificationCenter.default.addObserver(self, selector: #selector(handle(_:)), name: .dataRefreshed, object: nil)
            // Must call removeObserver(self) in deinit

        Pitfalls:
        1. Forgetting to remove observers → dangling callbacks, potential crashes (selector-based) or memory leaks (block-based tokens)
        2. No type safety — userInfo is [AnyHashable: Any]; cast errors are runtime
        3. Delivery thread is unspecified unless you pass queue: .main
        4. Hidden coupling — hard to trace who posts/observes what in a large codebase

        Prefer Combine / @Observable for new code. NotificationCenter is appropriate for system notifications (UIApplication.didBecomeActiveNotification, UIKeyboardWillShowNotification) that Apple posts and you observe.
        """,
        difficulty: .medium,
        topic: .swiftFundamentals
    ),
]

// MARK: - App Lifecycle

let appLifecycleCards: [ConceptCard] = [
    ConceptCard(
        question: "What is the difference between AppDelegate and SceneDelegate? How does multi-scene work?",
        answer: """
        Prior to iOS 13, AppDelegate managed the single app window and all lifecycle events. iOS 13 introduced SceneDelegate to support multiple windows (scenes) on iPad and Mac Catalyst.

        AppDelegate responsibilities (still):
        • Application launch (didFinishLaunchingWithOptions) — one-time setup, dependencies, push token registration
        • Remote notifications, background fetch, URL handling
        • App-level state (not per-scene)

        SceneDelegate responsibilities:
        • Per-scene window and UI setup (scene(_:willConnectTo:options:))
        • Scene foreground/background transitions:
          - sceneDidBecomeActive / sceneWillResignActive — fine-grained active state
          - sceneWillEnterForeground / sceneDidEnterBackground

        Multi-scene support (UIApplicationSupportsMultipleScenes = true in Info.plist):
        • Each scene gets its own SceneDelegate instance and UIWindow
        • iPad users can run two instances of your app side-by-side
        • State restoration is per-scene (NSUserActivity)

        SwiftUI apps (@main App struct):
        • Use WindowGroup / Window scene types — no AppDelegate/SceneDelegate required
        • @UIApplicationDelegateAdaptor to bridge AppDelegate callbacks when needed
        • Scene phases: @Environment(\\.scenePhase) — .active, .inactive, .background

        Common mistake: doing per-scene UI setup in AppDelegate — it runs before any scene is connected, so UIWindow doesn't exist yet.
        """,
        difficulty: .medium,
        topic: .appLifecycle
    ),
]

// MARK: - Architecture (additional)

let architectureAdditionalCards: [ConceptCard] = [
    ConceptCard(
        question: "What is the Singleton pattern? What are its trade-offs in iOS?",
        answer: """
        A singleton ensures a class has exactly one instance, accessed via a global point. Swift idiom:

            final class NetworkManager {
                static let shared = NetworkManager()
                private init() { }
            }

        Benefits:
        • Convenient global access — no need to pass the instance through every layer
        • Shared state: useful for app-wide resources (URLSession.shared, UserDefaults.standard, NotificationCenter.default)

        Trade-offs:
        • Hidden dependencies — callers reach into global state without declaring a dependency, making code harder to reason about
        • Untestable — tests can't inject a substitute; shared mutable state causes test ordering issues
        • Tight coupling — changing the singleton affects every consumer
        • Concurrency risks — shared mutable state across threads needs synchronization

        When singletons are appropriate:
        • Stateless utilities or when the "one instance" nature is truly a domain constraint
        • Apple's own singletons (URLSession.shared, UIApplication.shared) wrap system resources that are inherently singular

        Better alternatives:
        • Dependency injection — pass the dependency into the initializer, allowing test doubles
        • Service locator (slightly better than singleton; still has hidden-dependency problems)
        • Environment objects in SwiftUI

        Senior tip: replacing singletons with protocol-typed injected dependencies is one of the highest-ROI refactors for testability.
        """,
        difficulty: .medium,
        topic: .architecture
    ),
    ConceptCard(
        question: "What is VIPER and how does it compare to MVVM?",
        answer: """
        VIPER is a Clean Architecture-inspired pattern with five layers:

        • View — passive UI; forwards events to the Presenter
        • Interactor — contains business logic; fetches/processes data; calls back Presenter
        • Presenter — mediates between View and Interactor; formats data for display; handles navigation via Router
        • Entity — plain data models (no business logic)
        • Router — handles navigation/module creation; constructs the VIPER stack

        Data flow: View → Presenter → Interactor → (back) → Presenter → View. Router wired by Presenter.

        Compared to MVVM:
        | | MVVM | VIPER |
        |---|---|---|
        | Layers | 3 (Model, VM, View) | 5 |
        | Navigation | In ViewModel or Coordinator | Router layer |
        | Business logic | ViewModel | Interactor |
        | Complexity | Low-medium | High |
        | Boilerplate | Medium | High |
        | Testability | Good | Very good |

        When VIPER makes sense:
        • Large teams where strict boundaries prevent stepping on each other
        • Complex features with significant business logic distinct from presentation
        • Codebases with dedicated QA requiring high unit-test coverage per layer

        When it doesn't: small apps, solo projects, or when the overhead outweighs the benefit. MVVM + Coordinator covers most iOS apps well. VIPER shines in enterprise codebases with well-defined module boundaries.
        """,
        difficulty: .hard,
        topic: .architecture
    ),
]

// MARK: - Networking (additional)

let networkingAdditionalCards: [ConceptCard] = [
    ConceptCard(
        question: "What are the caching strategies available in iOS networking?",
        answer: """
        URLCache (HTTP caching):
        • Built into URLSession; caches responses according to HTTP Cache-Control headers
        • In-memory + on-disk storage configurable via URLCache(memoryCapacity:diskCapacity:directory:)
        • URLSessionConfiguration.urlCache — set a custom cache per session
        • Controlled by Cache-Control, Expires, ETag, Last-Modified headers from the server
        • URLRequest.cachePolicy overrides default behavior per-request:
          - .useProtocolCachePolicy (default)
          - .reloadIgnoringLocalCacheData (always fetch)
          - .returnCacheDataElseLoad (offline fallback)

        NSCache (in-memory object cache):
        • Key-value store that automatically evicts under memory pressure
        • Not persisted to disk; cleared on app termination
        • Ideal for decoded images, rendered thumbnails, expensive computed objects
        • Thread-safe; keys must be AnyObject (use NSString, not String)

            let imageCache = NSCache<NSString, UIImage>()
            imageCache.countLimit = 100

        Custom disk cache:
        • Write decoded data to Library/Caches/ — the OS can purge it; not backed up
        • Use FileManager + hashed URL strings as filenames
        • Libraries: Kingfisher (images), Nuke — handle multi-level caching automatically

        Choosing a strategy:
        • API responses with Cache-Control → let URLCache handle it automatically
        • Images / large blobs → NSCache (memory) + disk cache
        • Offline-first apps → explicit disk persistence (Core Data / SQLite + sync)
        """,
        difficulty: .medium,
        topic: .networking
    ),
]

// MARK: - Security

let securityCards: [ConceptCard] = [
    ConceptCard(
        question: "How do you store sensitive data securely on iOS? Explain the Keychain.",
        answer: """
        The Keychain is the recommended store for secrets: passwords, tokens, keys, certificates. It is:
        • Encrypted at rest by the OS
        • Protected by the device passcode / Secure Enclave
        • Persists across app reinstalls (unlike UserDefaults)
        • Shareable across apps via Keychain Access Groups (requires entitlement)

        Basic read/write using Security framework:
            // Write
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: "com.myapp.token",
                kSecAttrAccount: "user",
                kSecValueData: tokenData
            ]
            SecItemAdd(query as CFDictionary, nil)

            // Read
            var result: AnyObject?
            let readQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: "com.myapp.token",
                kSecAttrAccount: "user",
                kSecReturnData: true,
                kSecMatchLimit: kSecMatchLimitOne
            ]
            SecItemCopyMatching(readQuery as CFDictionary, &result)

        Accessibility levels (kSecAttrAccessible):
        • kSecAttrAccessibleWhenUnlocked — only when device unlocked (most common for tokens)
        • kSecAttrAccessibleAfterFirstUnlock — available in background after first unlock since restart (background networking)
        • Never use kSecAttrAccessibleAlways — unencrypted

        Libraries: KeychainAccess, SwiftKeychainWrapper — wrap the verbose C API.

        What NOT to use for sensitive data:
        • UserDefaults — unencrypted plist
        • Documents/ or files without Data Protection
        • NSURLCredentialStorage — less control over accessibility
        """,
        difficulty: .medium,
        topic: .security
    ),
    ConceptCard(
        question: "What are iOS app security best practices?",
        answer: """
        Data at rest:
        • Keychain for secrets (tokens, passwords, keys)
        • Enable Data Protection (NSFileProtectionComplete) for sensitive files
        • Never store PII in UserDefaults or unprotected files
        • Clear sensitive data from memory promptly (zero out buffers)

        Data in transit:
        • App Transport Security (ATS) enforces HTTPS by default — never disable NSAllowsArbitraryLoads in production
        • Certificate/public-key pinning for high-value endpoints
        • Validate server certificates; never override URLSession delegate to blindly accept all

        Code and binary:
        • Enable Pointer Authentication Codes (PAC) — default on arm64e
        • Strip debug symbols from release builds
        • Avoid logging sensitive values (tokens, PII) — use os_log with privacy annotations: os_log("token: %{private}@", token)

        Input validation:
        • Validate all data from external sources (network, pasteboard, URL schemes, shared containers)
        • Sanitize inputs used in Core Data predicates, SQL queries, or shell commands

        Jailbreak / tampering detection:
        • Check for suspicious file paths, dylib injection, or process flags
        • Do not rely on this as the sole security layer — treat it as defense-in-depth

        Secrets management:
        • Never hardcode API keys in source code — use xcconfig files excluded from version control, or server-side proxying
        • Rotate secrets; revoke compromised tokens server-side

        Privacy:
        • Request only the permissions you need (camera, location, contacts)
        • Use on-demand resources or server-side processing to avoid storing sensitive data on device longer than needed
        """,
        difficulty: .medium,
        topic: .security
    ),
]

// MARK: - Tooling

let toolingCards: [ConceptCard] = [
    ConceptCard(
        question: "Compare CocoaPods, Carthage, and Swift Package Manager.",
        answer: """
        CocoaPods:
        • Ruby-based; uses a Podfile and centralized Specs repo
        • Integrates by modifying the Xcode workspace — adds a Pods project
        • Huge ecosystem; supports almost every library
        • Downsides: requires Ruby toolchain, modifies project files heavily, slow pod install on large dependency trees, ties you to its workspace structure

        Carthage:
        • Decentralized; fetches + builds frameworks, you link them manually
        • Does not modify your Xcode project — you drag in built .xcframework files
        • Result: simpler integration, easier to audit
        • Downsides: slower (builds all dependencies from source), no central catalog, manual framework linkage step

        Swift Package Manager (SPM):
        • First-party; built into Swift and Xcode (no external tooling)
        • Integrates directly into Xcode project (Package.resolved for lockfile)
        • Supports libraries, executables, plugins, binary targets (.xcframework)
        • Fastest to set up; no workspace modifications
        • Downsides: some legacy ObjC-heavy or resource-bundle-heavy pods aren't yet SPM-compatible; limited support for certain build setting customizations

        Current recommendation:
        • SPM for new projects and any library that supports it
        • CocoaPods as fallback for libraries not yet on SPM
        • Carthage largely superseded by SPM in new projects

        Binary vs source dependencies:
        • SPM .binaryTarget (XCFramework) / CocoaPods vendored_frameworks: ship pre-built; faster CI, obfuscated internals
        • Source dependencies: auditable, customizable, built with your settings
        """,
        difficulty: .easy,
        topic: .tooling
    ),
    ConceptCard(
        question: "What is the difference between static and dynamic frameworks in iOS?",
        answer: """
        Static framework (.a + headers, or .framework with static lib):
        • Code is copied directly into the app binary at link time
        • App launch: no extra dylib loading — slightly faster pre-main startup
        • No sharing: each app/extension gets its own copy
        • Larger binary if the same library is linked into the app and multiple extensions

        Dynamic framework (.framework with .dylib):
        • Loaded at runtime by the dynamic linker; not copied into the main binary
        • Can be shared between the app and its extensions (app extensions can link the same framework)
        • Adds pre-main time: each dylib adds ~1–5ms loading overhead
        • Required for App Extensions that share code with the host app

        XCFramework:
        • A bundle containing multiple framework variants (device arm64, simulator x86_64/arm64)
        • Can be static or dynamic; single artifact works for all architectures
        • Preferred distribution format for binary SDKs (replacing fat/universal frameworks)

        Choosing:
        • Internal modules / app-only code: static (faster launch, simpler)
        • Shared between app + extension, or distributed as a binary SDK: dynamic / XCFramework
        • App size: dynamic frameworks don't reduce total size unless truly shared; static is often smaller overall

        CocoaPods generates dynamic frameworks by default (use_frameworks!); SPM products default to static unless explicitly declared dynamic.
        """,
        difficulty: .medium,
        topic: .tooling
    ),
]

// MARK: - Data Persistence

let dataPersistenceCards: [ConceptCard] = [
    ConceptCard(
        question: "What are the data persistence options in iOS and when do you use each?",
        answer: """
        UserDefaults: key-value store for small primitive values (settings, flags, user preferences). Backed by a plist. Never store sensitive data — not encrypted. Limit to a few KB; large blobs degrade app launch.

        Keychain: secure, encrypted storage for sensitive values (tokens, passwords, certificates). Persists across app reinstalls (unless explicitly removed). Access controlled by Keychain Access Groups for sharing across apps/extensions.

        File system (FileManager): arbitrary data (images, documents, caches) in app sandbox directories:
        • Documents/ — user-visible files, iCloud-backed
        • Library/Caches/ — purgeable by OS, not backed up
        • Library/Application Support/ — internal app data, backed up

        SQLite / GRDB / FMDB: relational data, complex queries, large datasets. Lower level than Core Data.

        Core Data: Apple's object graph + persistence framework built on SQLite (usually). Best for complex object relationships, undo/redo, faulting, and NSFetchedResultsController for live-updating UIs.

        SwiftData (iOS 17+): modern Swift-native persistence using macros (@Model). Wraps Core Data but with a cleaner API and native Swift concurrency support.

        Realm: third-party document-object database. Zero-copy reads, reactive change notifications, cross-platform (iOS + Android). Good alternative when Core Data is too heavy.
        """,
        difficulty: .easy,
        topic: .dataPersistence
    ),
    ConceptCard(
        question: "Explain Core Data's main components and the managed object context.",
        answer: """
        Core Data stack:
        • NSManagedObjectModel: the schema (entities, attributes, relationships) — defined in .xcdatamodeld
        • NSPersistentStore / NSPersistentStoreCoordinator: the actual storage backend (SQLite, binary, in-memory)
        • NSManagedObjectContext (MOC): the in-memory scratchpad where you create, read, update, delete objects

        NSManagedObjectContext key behaviors:
        • Changes are not persisted until you call context.save()
        • Each context is not thread-safe — use it only on the thread/queue it was created on
        • viewContext (main queue) for UI; backgroundContext for heavy fetches/batch operations
        • performAndWait / perform for safe cross-thread access

        Faulting: Core Data returns "fault" objects (placeholders) for relationships and deferred properties. Actual data loads on first access — good for memory, but can cause unexpected I/O.

        NSFetchedResultsController: monitors a fetch request and notifies delegates of changes — designed to power UITableView/UICollectionView with automatic inserts/deletes.

        NSPersistentCloudKitContainer: drop-in replacement for NSPersistentContainer that syncs to CloudKit. Requires iCloud entitlement.

        Common pitfall: passing NSManagedObjects across context boundaries. Use objectID to pass references and re-fetch in the target context.
        """,
        difficulty: .medium,
        topic: .dataPersistence
    ),
    ConceptCard(
        question: "What is SwiftData and how does it compare to Core Data?",
        answer: """
        SwiftData (iOS 17+) is Apple's modern persistence framework built on top of Core Data but with a native Swift API.

        Defining a model:
            @Model
            class Book {
                var title: String
                var author: String
                @Relationship(deleteRule: .cascade) var chapters: [Chapter]
            }
        The @Model macro generates the schema — no .xcdatamodeld file needed.

        Querying:
            @Query(sort: \\.title) var books: [Book]   // in a SwiftUI view
            // or
            let descriptor = FetchDescriptor<Book>(predicate: #Predicate { $0.author == "Tolkien" })
            let results = try modelContext.fetch(descriptor)

        Compared to Core Data:
        • Pros: Swift-native types, macros eliminate boilerplate, #Predicate is type-safe (vs. NSPredicate strings), natural async/await support with ModelActor
        • Cons: iOS 17+ only, less mature ecosystem, some advanced Core Data features (NSFetchedResultsController, batch operations) have no direct equivalent yet
        • Under the hood: SwiftData creates and uses a Core Data stack — you can even use both in the same app during migration

        ModelActor: the SwiftData equivalent of a background managed object context, conforming to the Swift actor model for safe concurrent access.
        """,
        difficulty: .medium,
        topic: .dataPersistence
    ),
]

// MARK: - Combine

let combineCards: [ConceptCard] = [
    ConceptCard(
        question: "What is Combine and what are its core concepts?",
        answer: """
        Combine is Apple's reactive programming framework (iOS 13+). It models asynchronous event streams using three core concepts:

        Publisher: emits a sequence of values over time, then completes or fails.
            • Output: the value type
            • Failure: the error type (Never if infallible)

        Subscriber: receives values, completion, or failure from a publisher.
            • sink(receiveValue:) — closure-based subscriber
            • assign(to:on:) — directly assigns values to a keypath

        Operator: transforms, filters, or combines publishers. Examples:
            • map, compactMap, filter — transform values
            • flatMap — chain publishers
            • debounce, throttle — time-based control
            • combineLatest, zip, merge — combine multiple publishers
            • receive(on:) — switch scheduler (e.g., to main queue)

        Cancellable / AnyCancellable: subscription lifecycle token. Store in a Set<AnyCancellable> to keep subscriptions alive. Cancels automatically when deallocated.

        Relationship to async/await: Combine is still useful for multi-value streams (NotificationCenter, continuous location updates). For one-shot async work, async/await is cleaner. The two integrate: publishers expose .values for async for-in loops.
        """,
        difficulty: .medium,
        topic: .combine
    ),
    ConceptCard(
        question: "What is @Published and how does it work with ObservableObject?",
        answer: """
        @Published is a property wrapper that wraps a value and publishes changes via a Combine publisher. The projected value ($property) is a Publisher.

        ObservableObject: a protocol requiring an objectWillChange: ObservableObjectPublisher. SwiftUI subscribes to this publisher and re-renders views on changes.

        How they connect:
        • @Published synthesizes willSet behavior that calls objectWillChange.send() before the value changes
        • SwiftUI's @ObservedObject and @StateObject subscribe to objectWillChange and schedule a view body re-evaluation

        Example:
            class SearchViewModel: ObservableObject {
                @Published var query = ""
                @Published private(set) var results: [Item] = []

                private var cancellables = Set<AnyCancellable>()

                init() {
                    $query
                        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
                        .removeDuplicates()
                        .sink { [weak self] q in
                            Task { await self?.search(q) }
                        }
                        .store(in: &cancellables)
                }
            }

        Thread safety: @Published must be mutated on the main actor if it drives SwiftUI. Mark the class @MainActor or dispatch updates to the main queue.

        Swift 5.9+: @Observable (Observation framework) replaces ObservableObject with finer-grained dependency tracking — only views reading a specific property re-render, not all observers.
        """,
        difficulty: .medium,
        topic: .combine
    ),
]

// MARK: - Combined list

let allConceptCards: [ConceptCard] =
    swiftFundamentalsCards +
    swiftFundamentalsAdditionalCards +
    memoryManagementCards +
    concurrencyCards +
    swiftUICards +
    uiKitCards +
    networkingCards +
    networkingAdditionalCards +
    architectureCards +
    architectureAdditionalCards +
    testingCards +
    performanceCards +
    dataPersistenceCards +
    combineCards +
    appLifecycleCards +
    securityCards +
    toolingCards
