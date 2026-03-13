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
]

// MARK: - Combined list

let allConceptCards: [ConceptCard] =
    swiftFundamentalsCards +
    memoryManagementCards +
    concurrencyCards +
    swiftUICards +
    uiKitCards +
    networkingCards +
    architectureCards +
    testingCards +
    performanceCards
