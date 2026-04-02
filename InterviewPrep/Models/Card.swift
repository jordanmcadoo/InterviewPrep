import Foundation

// MARK: - Enums

enum CardCategory: String, CaseIterable, Codable, Hashable {
    case concept = "Swift & iOS"
    case leetcode = "LeetCode"
    case discussion = "Technical Discussion"
    case behavioral = "Behavioral"

    var systemImage: String {
        switch self {
        case .concept:    return "swift"
        case .leetcode:   return "chevron.left.forwardslash.chevron.right"
        case .discussion: return "bubble.left.and.bubble.right"
        case .behavioral: return "person.fill.questionmark"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable, Comparable, Hashable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    static func < (lhs: Difficulty, rhs: Difficulty) -> Bool {
        let order: [Difficulty] = [.easy, .medium, .hard]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }

    var color: String {
        switch self {
        case .easy:   return "DifficultyEasy"
        case .medium: return "DifficultyMedium"
        case .hard:   return "DifficultyHard"
        }
    }
}

enum Company: String, CaseIterable, Codable, Hashable {
    case meta      = "Meta"
    case airbnb    = "Airbnb"
    case pinterest = "Pinterest"
    case dropbox   = "Dropbox"
}

enum AlgorithmPattern: String, CaseIterable, Codable, Hashable {
    case array            = "Array"
    case string           = "String"
    case hashMap          = "Hash Map"
    case slidingWindow    = "Sliding Window"
    case twoPointer       = "Two Pointer"
    case binarySearch     = "Binary Search"
    case linkedList       = "Linked List"
    case tree             = "Tree"
    case graph            = "Graph"
    case bfs              = "BFS"
    case dfs              = "DFS"
    case dynamicProgramming = "Dynamic Programming"
    case backtracking     = "Backtracking"
    case heap             = "Heap / Priority Queue"
    case trie             = "Trie"
    case stack            = "Stack"
    case intervals        = "Intervals"
    case matrix           = "Matrix"
    case bitManipulation  = "Bit Manipulation"
}

enum ConceptTopic: String, CaseIterable, Codable, Hashable {
    case swiftFundamentals = "Swift Fundamentals"
    case memoryManagement  = "Memory Management"
    case concurrency       = "Concurrency"
    case swiftUI           = "SwiftUI"
    case uiKit             = "UIKit"
    case networking        = "Networking"
    case architecture      = "Architecture"
    case testing           = "Testing"
    case performance       = "Performance"
    case dataStructures    = "Data Structures"
    case dataPersistence   = "Data Persistence"
    case combine           = "Combine"
    case appLifecycle      = "App Lifecycle"
    case security          = "Security"
    case tooling           = "Tooling"
}

// MARK: - Card Protocol

protocol Card: Identifiable {
    var id: UUID { get }
    var question: String { get }
    var answer: String { get }
    var category: CardCategory { get }
    var difficulty: Difficulty { get }
}

// MARK: - Concrete Card Types

struct ConceptCard: Card, Codable, Hashable {
    let id: UUID
    let question: String
    let answer: String
    let difficulty: Difficulty
    let topic: ConceptTopic
    var category: CardCategory { .concept }

    init(id: UUID = UUID(), question: String, answer: String,
         difficulty: Difficulty, topic: ConceptTopic) {
        self.id = id
        self.question = question
        self.answer = answer
        self.difficulty = difficulty
        self.topic = topic
    }
}

struct LeetCodeCard: Card, Codable, Hashable {
    let id: UUID
    let problemNumber: Int
    let title: String
    let question: String        // brief problem description
    let answer: String          // approach + complexity
    let difficulty: Difficulty
    let companies: Set<Company>
    let patterns: [AlgorithmPattern]
    let timeComplexity: String
    let spaceComplexity: String
    let leetcodeSlug: String
    var category: CardCategory { .leetcode }

    init(id: UUID = UUID(), problemNumber: Int, title: String,
         question: String, answer: String, difficulty: Difficulty,
         companies: Set<Company>, patterns: [AlgorithmPattern],
         timeComplexity: String, spaceComplexity: String, leetcodeSlug: String) {
        self.id = id
        self.problemNumber = problemNumber
        self.title = title
        self.question = question
        self.answer = answer
        self.difficulty = difficulty
        self.companies = companies
        self.patterns = patterns
        self.timeComplexity = timeComplexity
        self.spaceComplexity = spaceComplexity
        self.leetcodeSlug = leetcodeSlug
    }
}

struct DiscussionCard: Card, Codable, Hashable {
    let id: UUID
    let question: String
    let answer: String          // key talking points
    let difficulty: Difficulty
    let topic: ConceptTopic
    var category: CardCategory { .discussion }

    init(id: UUID = UUID(), question: String, answer: String,
         difficulty: Difficulty, topic: ConceptTopic) {
        self.id = id
        self.question = question
        self.answer = answer
        self.difficulty = difficulty
        self.topic = topic
    }
}

struct BehavioralCard: Card, Codable, Hashable {
    let id: UUID
    let question: String
    let answer: String          // STAR hints / key themes to hit
    let difficulty: Difficulty
    var category: CardCategory { .behavioral }

    init(id: UUID = UUID(), question: String, answer: String,
         difficulty: Difficulty = .medium) {
        self.id = id
        self.question = question
        self.answer = answer
        self.difficulty = difficulty
    }
}

// MARK: - Type-erased wrapper for heterogeneous collections

enum AnyCard: Identifiable, Hashable {
    case concept(ConceptCard)
    case leetcode(LeetCodeCard)
    case discussion(DiscussionCard)
    case behavioral(BehavioralCard)

    var id: UUID {
        switch self {
        case .concept(let c):    return c.id
        case .leetcode(let c):   return c.id
        case .discussion(let c): return c.id
        case .behavioral(let c): return c.id
        }
    }

    var question: String {
        switch self {
        case .concept(let c):    return c.question
        case .leetcode(let c):   return c.question
        case .discussion(let c): return c.question
        case .behavioral(let c): return c.question
        }
    }

    var answer: String {
        switch self {
        case .concept(let c):    return c.answer
        case .leetcode(let c):   return c.answer
        case .discussion(let c): return c.answer
        case .behavioral(let c): return c.answer
        }
    }

    var category: CardCategory {
        switch self {
        case .concept:    return .concept
        case .leetcode:   return .leetcode
        case .discussion: return .discussion
        case .behavioral: return .behavioral
        }
    }

    var difficulty: Difficulty {
        switch self {
        case .concept(let c):    return c.difficulty
        case .leetcode(let c):   return c.difficulty
        case .discussion(let c): return c.difficulty
        case .behavioral(let c): return c.difficulty
        }
    }

    var asLeetCode: LeetCodeCard? {
        if case .leetcode(let c) = self { return c }
        return nil
    }

    var asConceptTopic: ConceptTopic? {
        switch self {
        case .concept(let c):    return c.topic
        case .discussion(let c): return c.topic
        default: return nil
        }
    }
}
