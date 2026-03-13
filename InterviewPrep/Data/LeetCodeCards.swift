import Foundation

// MARK: - All companies shorthand
private let all4: Set<Company> = [.meta, .airbnb, .pinterest, .dropbox]
private let metaAirbnb: Set<Company> = [.meta, .airbnb]
private let metaDropbox: Set<Company> = [.meta, .dropbox]
private let airbnbPinterest: Set<Company> = [.airbnb, .pinterest]
private let metaAirbnbPinterest: Set<Company> = [.meta, .airbnb, .pinterest]
private let metaAirbnbDropbox: Set<Company> = [.meta, .airbnb, .dropbox]

// MARK: - Arrays & Hashing

let arraysHashingCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 1,
        title: "Two Sum",
        question: "Given an array of integers nums and an integer target, return indices of the two numbers that add up to target.",
        answer: """
        Approach: One-pass hash map.
        • Iterate through nums. For each element, check if (target - nums[i]) exists in the map.
        • If yes, return [map[complement], i].
        • If no, store nums[i] → i in the map.

        Key insight: store what we've seen; look up the complement in O(1).
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.array, .hashMap],
        timeComplexity: "O(n)",
        spaceComplexity: "O(n)",
        leetcodeSlug: "two-sum"
    ),
    LeetCodeCard(
        problemNumber: 49,
        title: "Group Anagrams",
        question: "Given an array of strings, group all anagrams together.",
        answer: """
        Approach: Sort each string as the key in a dictionary.
        • For each word, sort its characters → canonical key
        • Group words with the same key together
        • Return the dictionary's values

        Alternative: use character frequency array (26 ints) as key — O(n·k) instead of O(n·k·log k).
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.string, .hashMap],
        timeComplexity: "O(n · k log k)",
        spaceComplexity: "O(n · k)",
        leetcodeSlug: "group-anagrams"
    ),
    LeetCodeCard(
        problemNumber: 347,
        title: "Top K Frequent Elements",
        question: "Given an integer array and an integer k, return the k most frequent elements.",
        answer: """
        Approach A (Heap): Build frequency map, push to min-heap of size k. O(n log k).

        Approach B (Bucket Sort — optimal):
        • Build frequency map
        • Create bucket array of size n+1 where bucket[freq] = [elements with that frequency]
        • Scan buckets from high to low frequency, collect until k elements found
        • O(n) time — better than heap for this problem

        Interview tip: mention both approaches and their trade-offs.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.array, .hashMap, .heap],
        timeComplexity: "O(n)",
        spaceComplexity: "O(n)",
        leetcodeSlug: "top-k-frequent-elements"
    ),
    LeetCodeCard(
        problemNumber: 238,
        title: "Product of Array Except Self",
        question: "Return an array where each element is the product of all elements except itself. No division allowed.",
        answer: """
        Approach: Two-pass prefix/suffix products.
        • Pass 1 (left to right): result[i] = product of all elements to the left of i
        • Pass 2 (right to left): multiply result[i] by the running product of elements to the right

        This avoids division and handles zeros naturally.
        No extra array needed for suffix (use a running variable).
        """,
        difficulty: .medium,
        companies: metaDropbox,
        patterns: [.array],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1) (excluding output)",
        leetcodeSlug: "product-of-array-except-self"
    ),
    LeetCodeCard(
        problemNumber: 128,
        title: "Longest Consecutive Sequence",
        question: "Given an unsorted array of integers, find the length of the longest consecutive elements sequence in O(n).",
        answer: """
        Approach: Hash set + only start counting from sequence beginnings.
        • Put all numbers in a Set
        • For each number n, only begin counting if (n-1) is NOT in the set (i.e., n starts a sequence)
        • Count up: n+1, n+2, ... while present in set
        • Track max length

        Key insight: O(n) because each number is visited at most twice (once as start check, once during a count).
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.array, .hashMap],
        timeComplexity: "O(n)",
        spaceComplexity: "O(n)",
        leetcodeSlug: "longest-consecutive-sequence"
    ),
]

// MARK: - Two Pointers

let twoPointerCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 15,
        title: "3Sum",
        question: "Find all unique triplets in the array that sum to zero.",
        answer: """
        Approach: Sort + two pointers.
        • Sort the array
        • Fix one element (i), use left/right pointers to find pairs summing to -nums[i]
        • Skip duplicates: if nums[i] == nums[i-1] skip; after finding a triplet, skip duplicate lefts/rights
        • O(n²) — sorting O(n log n) + O(n) outer loop × O(n) two-pointer scan

        Common mistake: not handling duplicates correctly — practice this.
        """,
        difficulty: .medium,
        companies: metaAirbnbDropbox,
        patterns: [.array, .twoPointer],
        timeComplexity: "O(n²)",
        spaceComplexity: "O(1) (excluding output)",
        leetcodeSlug: "3sum"
    ),
    LeetCodeCard(
        problemNumber: 11,
        title: "Container With Most Water",
        question: "Given an array of heights, find two lines that form a container with the most water.",
        answer: """
        Approach: Greedy two pointers.
        • Start with pointers at both ends (widest possible container)
        • Area = min(height[l], height[r]) × (r - l)
        • Move the pointer with the smaller height inward (can only improve by getting a taller line)
        • Track max area

        Key insight: moving the taller pointer inward can only decrease area (width decreases, height won't improve). Moving the shorter one is the only chance to find better.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.array, .twoPointer],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "container-with-most-water"
    ),
    LeetCodeCard(
        problemNumber: 42,
        title: "Trapping Rain Water",
        question: "Given an elevation map, compute how much water it can trap after raining.",
        answer: """
        Approach A (two pointers — O(1) space):
        • Track maxLeft and maxRight
        • Move the pointer from the side with the smaller max height
        • Water at position = min(maxLeft, maxRight) - height[i]
        • If height is higher than current max, update max; else add the trapped water

        Approach B: prefix max arrays — easier to reason about, O(n) space.

        Senior insight: explain both approaches and why the two-pointer works (the trapped water at any point is bounded by the minimum of the maximums on each side).
        """,
        difficulty: .hard,
        companies: all4,
        patterns: [.array, .twoPointer, .stack],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "trapping-rain-water"
    ),
]

// MARK: - Sliding Window

let slidingWindowCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 3,
        title: "Longest Substring Without Repeating Characters",
        question: "Given a string, find the length of the longest substring without repeating characters.",
        answer: """
        Approach: Sliding window with hash map (char → last seen index).
        • Expand right pointer; when a duplicate is found, move left pointer to max(left, lastSeen[char] + 1)
        • Track window size (right - left + 1) and max

        Alternative: hash set + left pointer advancement.

        Key insight: the 'max(left, ...)' is critical — ensures left never moves backward when a char was seen before the current window.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.slidingWindow, .hashMap, .string],
        timeComplexity: "O(n)",
        spaceComplexity: "O(min(m,n)) where m is charset size",
        leetcodeSlug: "longest-substring-without-repeating-characters"
    ),
    LeetCodeCard(
        problemNumber: 76,
        title: "Minimum Window Substring",
        question: "Find the minimum window in string s that contains all characters of string t.",
        answer: """
        Approach: Sliding window with two frequency maps.
        • Build target frequency map from t
        • Expand right: add char to window map; when a char meets its required frequency, increment 'have' counter
        • When have == need (all required chars satisfied): try to shrink from left, updating best window
        • Shrink left: decrement window map; if a char drops below required, decrement 'have'

        Track: best (length, left, right) tuple. Return s[bestLeft...bestRight].

        This is a classic hard sliding window — practice until you can write it without hints.
        """,
        difficulty: .hard,
        companies: all4,
        patterns: [.slidingWindow, .hashMap, .string],
        timeComplexity: "O(n + m)",
        spaceComplexity: "O(m) where m = |t|",
        leetcodeSlug: "minimum-window-substring"
    ),
    LeetCodeCard(
        problemNumber: 424,
        title: "Longest Repeating Character Replacement",
        question: "Given a string and integer k, find the longest substring you can get by replacing at most k characters to make all characters the same.",
        answer: """
        Approach: Sliding window.
        • Track frequency of each char in the current window with a map
        • Window is valid if: (window size) - (max frequency in window) ≤ k
        • If invalid, shrink left (remove s[left] from map, advance left)
        • Track max window length

        Key insight: We only need to track the maximum frequency seen so far (it never decreases in a valid window), allowing O(1) validity check.
        """,
        difficulty: .medium,
        companies: metaAirbnb,
        patterns: [.slidingWindow, .hashMap, .string],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1) (26 char map)",
        leetcodeSlug: "longest-repeating-character-replacement"
    ),
]

// MARK: - Binary Search

let binarySearchCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 153,
        title: "Find Minimum in Rotated Sorted Array",
        question: "Find the minimum element in a rotated sorted array (no duplicates).",
        answer: """
        Approach: Modified binary search.
        • If nums[mid] > nums[right], minimum is in the right half
        • Otherwise, minimum is in the left half (including mid)
        • Continue until left == right

        Key insight: the minimum is at the inflection point of the rotation. Comparing mid to right tells you which half is "sorted normally."
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.binarySearch, .array],
        timeComplexity: "O(log n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "find-minimum-in-rotated-sorted-array"
    ),
    LeetCodeCard(
        problemNumber: 33,
        title: "Search in Rotated Sorted Array",
        question: "Search for a target in a rotated sorted array. Return its index or -1.",
        answer: """
        Approach: Modified binary search — determine which half is sorted, then check if target is in that half.
        • If left half sorted (nums[left] ≤ nums[mid]):
          - if target in [nums[left], nums[mid]]: search left half
          - else: search right half
        • Else right half is sorted:
          - if target in [nums[mid], nums[right]]: search right half
          - else: search left half

        Must handle the two cases carefully with closed interval comparisons.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.binarySearch, .array],
        timeComplexity: "O(log n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "search-in-rotated-sorted-array"
    ),
]

// MARK: - Linked Lists

let linkedListCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 206,
        title: "Reverse Linked List",
        question: "Reverse a singly linked list.",
        answer: """
        Iterative approach:
        • prev = nil, curr = head
        • While curr != nil: save next, point curr.next to prev, advance prev and curr
        • Return prev (new head)

        Recursive approach:
        • Base case: nil or single node → return head
        • Recurse to end: let newHead = reverse(head.next)
        • head.next.next = head; head.next = nil
        • Return newHead

        Know both. Iterative is O(1) space; recursive is O(n) stack space.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.linkedList],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1) iterative",
        leetcodeSlug: "reverse-linked-list"
    ),
    LeetCodeCard(
        problemNumber: 21,
        title: "Merge Two Sorted Lists",
        question: "Merge two sorted linked lists and return the sorted result.",
        answer: """
        Approach: Dummy head + compare and advance.
        • Use a dummy node to avoid edge cases at the head
        • Compare list1.val vs list2.val; append smaller, advance that pointer
        • When one list is exhausted, append the remainder of the other
        • Return dummy.next

        Recursive version is elegant but uses O(n) stack.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.linkedList],
        timeComplexity: "O(n + m)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "merge-two-sorted-lists"
    ),
    LeetCodeCard(
        problemNumber: 141,
        title: "Linked List Cycle",
        question: "Determine if a linked list has a cycle.",
        answer: """
        Approach: Floyd's tortoise & hare.
        • slow pointer advances 1 step; fast pointer advances 2 steps
        • If they ever meet, there's a cycle
        • If fast reaches nil, no cycle

        To find cycle start (LC 142): after meeting, move one pointer to head, advance both 1 step at a time — they meet at the cycle entrance.

        Interview follow-up: why does this work? The math: they meet at some point k steps into the cycle, and moving one pointer to head and advancing both by 1 brings them to the cycle entrance.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.linkedList, .twoPointer],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "linked-list-cycle"
    ),
    LeetCodeCard(
        problemNumber: 23,
        title: "Merge K Sorted Lists",
        question: "Merge k sorted linked lists into one sorted list.",
        answer: """
        Approach A (Min-Heap — optimal):
        • Push the head of each list into a min-heap keyed by node value
        • Pop minimum, append to result, push that node's next into heap
        • O(n log k) where n = total nodes, k = number of lists

        Approach B (Divide and Conquer):
        • Pair up lists and merge each pair
        • Repeat until one list remains
        • O(n log k)

        Approach C (naive sequential merging): O(n·k) — mention and dismiss.

        Min-heap is the classic interview answer for this.
        """,
        difficulty: .hard,
        companies: metaAirbnbDropbox,
        patterns: [.linkedList, .heap],
        timeComplexity: "O(n log k)",
        spaceComplexity: "O(k)",
        leetcodeSlug: "merge-k-sorted-lists"
    ),
    LeetCodeCard(
        problemNumber: 19,
        title: "Remove Nth Node From End of List",
        question: "Remove the nth node from the end of a linked list in one pass.",
        answer: """
        Approach: Two pointers with n+1 gap.
        • Use dummy node pointing to head
        • Advance fast pointer n+1 steps from dummy
        • Advance both until fast reaches nil
        • slow.next is the node to remove — set slow.next = slow.next?.next

        The n+1 gap ensures slow lands on the node BEFORE the target, enabling clean removal.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.linkedList, .twoPointer],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "remove-nth-node-from-end-of-list"
    ),
]

// MARK: - Trees

let treeCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 226,
        title: "Invert Binary Tree",
        question: "Invert (mirror) a binary tree.",
        answer: """
        Approach: Recursive DFS.
        • Swap root.left and root.right
        • Recursively invert both subtrees
        • Base case: nil → return nil

        BFS/iterative: use a queue; for each node, swap children and enqueue them.

        This is famously "the problem Homebrew's creator couldn't solve in a Google interview" — don't overthink it.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.tree, .dfs, .bfs],
        timeComplexity: "O(n)",
        spaceComplexity: "O(h) where h = height",
        leetcodeSlug: "invert-binary-tree"
    ),
    LeetCodeCard(
        problemNumber: 104,
        title: "Maximum Depth of Binary Tree",
        question: "Find the maximum depth (number of nodes along the longest root-to-leaf path).",
        answer: """
        Recursive: max(depth(left), depth(right)) + 1. Base case: nil → 0.

        BFS (level order): count levels — increment depth for each level in the queue.

        Iterative DFS: use a stack of (node, depth) tuples, track max depth.

        This is often the warm-up tree problem — answer confidently and quickly.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.tree, .dfs, .bfs],
        timeComplexity: "O(n)",
        spaceComplexity: "O(h)",
        leetcodeSlug: "maximum-depth-of-binary-tree"
    ),
    LeetCodeCard(
        problemNumber: 100,
        title: "Same Tree",
        question: "Given two binary trees, check if they are structurally identical with the same node values.",
        answer: """
        Recursive:
        • Both nil → true
        • One nil → false
        • Values differ → false
        • Recurse: isSame(p.left, q.left) && isSame(p.right, q.right)

        BFS alternative: level-order traverse both trees simultaneously, compare node by node.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.tree, .dfs],
        timeComplexity: "O(n)",
        spaceComplexity: "O(h)",
        leetcodeSlug: "same-tree"
    ),
    LeetCodeCard(
        problemNumber: 572,
        title: "Subtree of Another Tree",
        question: "Given two trees root and subRoot, check if subRoot is a subtree of root.",
        answer: """
        Approach: DFS + isSameTree helper.
        • For each node in root, check if the subtree rooted there is identical to subRoot using isSameTree
        • Recurse into left and right children

        Optimization: compare by hash/serialization to avoid repeated full comparisons — O(m + n) with hashing.

        Base brute force: O(m·n). Acceptable for most interview sizes.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.tree, .dfs],
        timeComplexity: "O(m·n)",
        spaceComplexity: "O(h)",
        leetcodeSlug: "subtree-of-another-tree"
    ),
    LeetCodeCard(
        problemNumber: 235,
        title: "Lowest Common Ancestor of a BST",
        question: "Find the lowest common ancestor of two nodes in a BST.",
        answer: """
        BST property makes this efficient:
        • If both p and q are less than root → LCA is in left subtree
        • If both p and q are greater than root → LCA is in right subtree
        • Otherwise (they split, or one equals root) → root is the LCA

        No need for a general tree traversal — the BST property guides you directly.
        O(h) — O(log n) balanced, O(n) worst case.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.tree, .dfs],
        timeComplexity: "O(h)",
        spaceComplexity: "O(h) recursive, O(1) iterative",
        leetcodeSlug: "lowest-common-ancestor-of-a-binary-search-tree"
    ),
    LeetCodeCard(
        problemNumber: 102,
        title: "Binary Tree Level Order Traversal",
        question: "Return the level-order traversal of a binary tree's node values (by level, left to right).",
        answer: """
        BFS with queue:
        • Enqueue root
        • Each iteration: record current queue size (nodes at this level), dequeue all of them, collect values, enqueue their children
        • This gives you each level as a separate array

        The "record queue size before processing" pattern is key — it's how you isolate each level.

        Returns [[Int]] — outer array is levels, inner is nodes per level.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.tree, .bfs],
        timeComplexity: "O(n)",
        spaceComplexity: "O(n) (width of widest level)",
        leetcodeSlug: "binary-tree-level-order-traversal"
    ),
    LeetCodeCard(
        problemNumber: 98,
        title: "Validate Binary Search Tree",
        question: "Determine if a binary tree is a valid BST.",
        answer: """
        Approach: Pass valid range (min, max) through recursive calls.
        • Root: range = (-∞, +∞)
        • Left child: range = (min, root.val)
        • Right child: range = (root.val, max)
        • A node is invalid if its value is out of its range

        Common wrong approach: only comparing a node to its immediate children — misses cases where a node in the left subtree is greater than an ancestor.

        In-order traversal approach: in-order of a valid BST is strictly increasing — check that each visited value is greater than the previous.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.tree, .dfs],
        timeComplexity: "O(n)",
        spaceComplexity: "O(h)",
        leetcodeSlug: "validate-binary-search-tree"
    ),
    LeetCodeCard(
        problemNumber: 230,
        title: "Kth Smallest Element in a BST",
        question: "Find the kth smallest value in a BST.",
        answer: """
        Approach: In-order traversal (left, root, right) yields sorted order for BST.
        • Perform in-order DFS, decrement k at each visit
        • When k == 0, record the current node value

        Iterative version with explicit stack: more control, useful for follow-up (stream of values).

        Follow-up: if the BST is frequently modified and we need frequent kth queries, augment each node with its subtree size to navigate directly in O(h).
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.tree, .dfs],
        timeComplexity: "O(h + k)",
        spaceComplexity: "O(h)",
        leetcodeSlug: "kth-smallest-element-in-a-bst"
    ),
    LeetCodeCard(
        problemNumber: 124,
        title: "Binary Tree Maximum Path Sum",
        question: "Find the maximum path sum in a binary tree. A path can start and end at any node.",
        answer: """
        Approach: Recursive DFS with global maximum.
        • For each node, compute: max gain from left subtree (0 if negative), max gain from right subtree (0 if negative)
        • Path through current node = node.val + leftGain + rightGain — update global max
        • Return to parent: node.val + max(leftGain, rightGain) — a path can only go one direction up

        Key insight: when computing the return value for the parent, you can only extend in one direction (you can't "fork" the path upward).

        Use Int.min as initial globalMax, not 0 (path sum can be negative).
        """,
        difficulty: .hard,
        companies: metaAirbnb,
        patterns: [.tree, .dfs],
        timeComplexity: "O(n)",
        spaceComplexity: "O(h)",
        leetcodeSlug: "binary-tree-maximum-path-sum"
    ),
    LeetCodeCard(
        problemNumber: 297,
        title: "Serialize and Deserialize Binary Tree",
        question: "Design an algorithm to serialize a binary tree to a string and deserialize it back.",
        answer: """
        Approach: Pre-order DFS with null markers.

        Serialize: pre-order traversal — append node value or "N" for null, comma-separated.

        Deserialize: split string, use an index pointer (or queue of tokens).
        • Read next token: if "N" return nil, else create node with value
        • Recursively assign left = deserialize(), right = deserialize()

        The pre-order format uniquely encodes the tree with null markers. BFS/level-order also works.

        This is a design problem — mention trade-offs (BFS easier to read, DFS more concise for unbalanced trees).
        """,
        difficulty: .hard,
        companies: all4,
        patterns: [.tree, .dfs, .bfs],
        timeComplexity: "O(n)",
        spaceComplexity: "O(n)",
        leetcodeSlug: "serialize-and-deserialize-binary-tree"
    ),
]

// MARK: - Tries

let trieCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 208,
        title: "Implement Trie (Prefix Tree)",
        question: "Implement a trie with insert, search, and startsWith methods.",
        answer: """
        TrieNode: dictionary of children [Character: TrieNode], isEndOfWord flag.

        insert: iterate chars, create nodes as needed, mark isEndOfWord on last.
        search: traverse nodes for each char; return node exists AND isEndOfWord.
        startsWith: traverse nodes for each char; return node exists (no isEndOfWord check).

        Use cases: autocomplete, spell checking, IP routing tables.

        Space optimization: use array[26] instead of dictionary for lowercase-only input.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.trie],
        timeComplexity: "O(m) per op, m = word length",
        spaceComplexity: "O(m · n) total",
        leetcodeSlug: "implement-trie-prefix-tree"
    ),
]

// MARK: - Heap / Priority Queue

let heapCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 295,
        title: "Find Median from Data Stream",
        question: "Design a data structure that supports addNum and findMedian operations on a running stream.",
        answer: """
        Approach: Two heaps.
        • maxHeap (lower half): Swift's Heap or simulated with negated values in a min-heap
        • minHeap (upper half): regular min-heap
        • Invariant: maxHeap.count == minHeap.count OR maxHeap.count == minHeap.count + 1

        addNum:
        1. Push to maxHeap, then pop max from maxHeap into minHeap (balances)
        2. If minHeap is larger, pop from minHeap back to maxHeap

        findMedian: if counts equal → average of both tops; else → maxHeap top.

        O(log n) add, O(1) median.
        """,
        difficulty: .hard,
        companies: all4,
        patterns: [.heap],
        timeComplexity: "O(log n) add, O(1) findMedian",
        spaceComplexity: "O(n)",
        leetcodeSlug: "find-median-from-data-stream"
    ),
]

// MARK: - Graphs

let graphCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 200,
        title: "Number of Islands",
        question: "Given a 2D grid of '1's (land) and '0's (water), count the number of islands.",
        answer: """
        Approach: DFS/BFS flood fill.
        • Iterate every cell; when '1' is found, increment count and flood fill that island
        • Flood fill: mark cell as visited ('0' or separate visited set), recurse in 4 directions
        • Continue until no '1' neighbor

        BFS alternative: use a queue instead of recursion (avoids stack overflow for large grids).

        Union-Find is a third approach — useful if you also need to track island sizes.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.graph, .dfs, .bfs, .matrix],
        timeComplexity: "O(m·n)",
        spaceComplexity: "O(m·n) worst case recursion",
        leetcodeSlug: "number-of-islands"
    ),
    LeetCodeCard(
        problemNumber: 133,
        title: "Clone Graph",
        question: "Given a reference to a node in a connected undirected graph, return a deep copy of the graph.",
        answer: """
        Approach: BFS or DFS + hash map (original node → cloned node).
        • Start with the given node, create its clone, add to map
        • BFS: for each neighbor, if not in map create clone; add to current clone's neighbors; enqueue
        • The map prevents visiting/cloning the same node twice (handles cycles)

        DFS recursive version: check map for existing clone → return it; else create, recurse neighbors.

        The map is critical for handling cycles — without it you'd infinite loop.
        """,
        difficulty: .medium,
        companies: metaAirbnb,
        patterns: [.graph, .dfs, .bfs, .hashMap],
        timeComplexity: "O(V + E)",
        spaceComplexity: "O(V)",
        leetcodeSlug: "clone-graph"
    ),
    LeetCodeCard(
        problemNumber: 417,
        title: "Pacific Atlantic Water Flow",
        question: "Find cells from which water can flow to both the Pacific and Atlantic oceans.",
        answer: """
        Approach: Reverse BFS/DFS from ocean borders.
        • Instead of simulating water flow from each cell, work backward from ocean boundaries
        • BFS from all Pacific-border cells: mark reachable cells as pacific-reachable
        • BFS from all Atlantic-border cells: mark reachable cells as atlantic-reachable
        • Answer: cells marked in both sets

        Reverse the flow condition: a cell is "reachable" from an ocean if its neighbor is lower-or-equal height (water can flow up from ocean border in the reverse direction).
        """,
        difficulty: .medium,
        companies: airbnbPinterest,
        patterns: [.graph, .bfs, .dfs, .matrix],
        timeComplexity: "O(m·n)",
        spaceComplexity: "O(m·n)",
        leetcodeSlug: "pacific-atlantic-water-flow"
    ),
    LeetCodeCard(
        problemNumber: 207,
        title: "Course Schedule",
        question: "Determine if you can finish all courses given prerequisites (detect cycle in directed graph).",
        answer: """
        Approach A (Topological Sort - BFS/Kahn's):
        • Build adjacency list and in-degree array
        • Enqueue all nodes with in-degree 0
        • Process: decrement neighbors' in-degrees; enqueue those reaching 0
        • If total processed == numCourses, no cycle

        Approach B (DFS cycle detection):
        • Three states: unvisited, visiting (in current DFS path), visited (fully processed)
        • If we reach a 'visiting' node, cycle detected

        Both O(V + E). Kahn's is often cleaner to implement.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.graph, .dfs, .bfs],
        timeComplexity: "O(V + E)",
        spaceComplexity: "O(V + E)",
        leetcodeSlug: "course-schedule"
    ),
    LeetCodeCard(
        problemNumber: 323,
        title: "Number of Connected Components in an Undirected Graph",
        question: "Given n nodes and edges, find the number of connected components.",
        answer: """
        Approach A (Union-Find):
        • Initialize parent[i] = i, count = n
        • For each edge: union the two nodes; if they were in different sets, decrement count
        • Return count

        Approach B (DFS/BFS):
        • For each unvisited node, run DFS/BFS marking all reachable nodes, increment component count

        Union-Find is elegant and O(α(n)) ≈ O(1) per operation.

        Premium problem on LeetCode — understand it as a Union-Find template problem.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.graph, .dfs, .bfs],
        timeComplexity: "O(V + E)",
        spaceComplexity: "O(V)",
        leetcodeSlug: "number-of-connected-components-in-an-undirected-graph"
    ),
    LeetCodeCard(
        problemNumber: 261,
        title: "Graph Valid Tree",
        question: "Given n nodes and edges, determine if they form a valid tree.",
        answer: """
        A graph is a valid tree if: (1) it has exactly n-1 edges, and (2) all nodes are connected (no cycles, no separate components).

        Approach (Union-Find):
        • Check edges.count == n - 1 first (necessary condition)
        • For each edge, union the two nodes; if they're already in the same set → cycle → return false
        • After processing all edges, verify all nodes are connected (count == 1 or check root)

        DFS/BFS alternative: start DFS from node 0, if we visit n nodes and see no back edges, it's a tree.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.graph, .dfs],
        timeComplexity: "O(V + E)",
        spaceComplexity: "O(V)",
        leetcodeSlug: "graph-valid-tree"
    ),
]

// MARK: - Dynamic Programming

let dpCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 70,
        title: "Climbing Stairs",
        question: "You can climb 1 or 2 steps at a time. How many distinct ways to climb n stairs?",
        answer: """
        This is Fibonacci:  f(n) = f(n-1) + f(n-2), f(1) = 1, f(2) = 2.

        Bottom-up DP: iterate from 1 to n, keeping only the last two values.
        Space: O(1) with two variables.

        Generalization (good follow-up): what if you can take k steps? Use a sliding window sum.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.dynamicProgramming],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "climbing-stairs"
    ),
    LeetCodeCard(
        problemNumber: 322,
        title: "Coin Change",
        question: "Find the fewest coins needed to make up a given amount.",
        answer: """
        Bottom-up DP:
        • dp[0] = 0; dp[i] = min coins to make amount i
        • For each amount from 1..amount: dp[i] = min(dp[i], dp[i - coin] + 1) for each coin ≤ i
        • Initialize dp[1..] = amount + 1 (infinity placeholder)
        • Return dp[amount] if ≤ amount, else -1

        This is the canonical unbounded knapsack problem. Understand it well — many DP variations build on it.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.dynamicProgramming],
        timeComplexity: "O(amount × coins)",
        spaceComplexity: "O(amount)",
        leetcodeSlug: "coin-change"
    ),
    LeetCodeCard(
        problemNumber: 300,
        title: "Longest Increasing Subsequence",
        question: "Find the length of the longest strictly increasing subsequence.",
        answer: """
        Approach A (DP) — O(n²):
        • dp[i] = length of LIS ending at index i
        • For each i: dp[i] = max(dp[j] + 1) for all j < i where nums[j] < nums[i]

        Approach B (Patience Sorting with Binary Search) — O(n log n):
        • Maintain a 'tails' array where tails[i] = smallest tail of all LIS of length i+1
        • For each num: binary search for the leftmost tail ≥ num, replace it (or append if larger than all)
        • Length of tails = length of LIS

        For interviews, explain both; implement whichever you're more confident with.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.dynamicProgramming, .binarySearch],
        timeComplexity: "O(n log n) optimal",
        spaceComplexity: "O(n)",
        leetcodeSlug: "longest-increasing-subsequence"
    ),
    LeetCodeCard(
        problemNumber: 198,
        title: "House Robber",
        question: "Rob houses along a street; can't rob adjacent houses. Maximize total amount robbed.",
        answer: """
        DP recurrence: dp[i] = max(dp[i-1], dp[i-2] + nums[i])
        • Either skip house i (take dp[i-1]) or rob it (take dp[i-2] + nums[i])

        Space-optimized: only keep prev2 and prev1 variables.

        Base cases: dp[0] = nums[0], dp[1] = max(nums[0], nums[1])

        Classic DP warm-up; House Robber II (circular array) adds one more constraint — run the DP twice: once excluding first house, once excluding last, take the max.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.dynamicProgramming],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "house-robber"
    ),
    LeetCodeCard(
        problemNumber: 91,
        title: "Decode Ways",
        question: "A string of digits can map to letters (1→A ... 26→Z). Count the number of ways to decode it.",
        answer: """
        DP: dp[i] = number of ways to decode s[0..i-1].
        • Single digit decode: if s[i-1] != '0', dp[i] += dp[i-1]
        • Two digit decode: let twoDigit = Int(s[i-2...i-1]); if 10 ≤ twoDigit ≤ 26, dp[i] += dp[i-2]

        Base: dp[0] = 1 (empty string), dp[1] = (s[0] != '0') ? 1 : 0

        Edge cases: leading zeros, standalone zeros, "00" → all invalid (return 0).
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.dynamicProgramming, .string],
        timeComplexity: "O(n)",
        spaceComplexity: "O(n) or O(1) space-optimized",
        leetcodeSlug: "decode-ways"
    ),
    LeetCodeCard(
        problemNumber: 139,
        title: "Word Break",
        question: "Given a string and a dictionary of words, determine if the string can be segmented into dictionary words.",
        answer: """
        DP: dp[i] = true if s[0..i-1] can be segmented.
        • dp[0] = true (empty string)
        • For i from 1 to n: for j from 0 to i: if dp[j] && s[j..i-1] in dictionary → dp[i] = true

        Optimization: store wordDict in a Set for O(1) lookup.

        Memoized DFS alternative: same idea, top-down.

        Follow-up: Word Break II (return all segmentations) — use backtracking with memoization.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.dynamicProgramming, .hashMap],
        timeComplexity: "O(n² × m) where m = avg word length",
        spaceComplexity: "O(n)",
        leetcodeSlug: "word-break"
    ),
    LeetCodeCard(
        problemNumber: 55,
        title: "Jump Game",
        question: "Given an array where each element is the max jump length, determine if you can reach the last index.",
        answer: """
        Greedy:
        • Track the furthest reachable index (maxReach)
        • For each index i: if i > maxReach → can't reach here → return false
        • Update maxReach = max(maxReach, i + nums[i])
        • If loop completes, return true

        This is O(n) time, O(1) space. A DP solution exists but is O(n²) — the greedy is better.

        Follow-up (Jump Game II): minimum jumps — greedy BFS-style, tracking current jump range and next jump range.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.dynamicProgramming, .array],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "jump-game"
    ),
    LeetCodeCard(
        problemNumber: 62,
        title: "Unique Paths",
        question: "Count the number of unique paths from top-left to bottom-right of an m×n grid (moving only right or down).",
        answer: """
        DP: dp[i][j] = paths to cell (i,j) = dp[i-1][j] + dp[i][j-1].
        Base: first row and first column are all 1s.

        Space optimization: 1D array, update in-place left to right.

        Math shortcut: C(m+n-2, m-1) — choosing which m-1 of the m+n-2 moves are "down".
        For an interview, the DP solution is clearest. Mention the math for bonus points.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.dynamicProgramming, .matrix],
        timeComplexity: "O(m·n)",
        spaceComplexity: "O(n) space-optimized",
        leetcodeSlug: "unique-paths"
    ),
]

// MARK: - Intervals

let intervalCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 56,
        title: "Merge Intervals",
        question: "Given an array of intervals, merge all overlapping intervals.",
        answer: """
        Approach:
        1. Sort intervals by start time
        2. Initialize result with first interval
        3. For each subsequent interval:
           - If it overlaps with the last interval in result (start ≤ last.end), merge: update last.end = max(last.end, current.end)
           - Otherwise, append as new interval

        Key: sorting first ensures overlapping intervals are adjacent.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.intervals, .array],
        timeComplexity: "O(n log n)",
        spaceComplexity: "O(n)",
        leetcodeSlug: "merge-intervals"
    ),
    LeetCodeCard(
        problemNumber: 57,
        title: "Insert Interval",
        question: "Insert a new interval into a sorted, non-overlapping list of intervals and merge if necessary.",
        answer: """
        Three-phase approach:
        1. Add all intervals that end before newInterval starts (no overlap, newInterval.start > interval.end)
        2. Merge all overlapping intervals with newInterval: while newInterval.start ≤ interval.end, update newInterval = [min(starts), max(ends)]
        3. Add the merged newInterval, then all remaining intervals

        No sorting needed — array is already sorted. O(n) time.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.intervals, .array],
        timeComplexity: "O(n)",
        spaceComplexity: "O(n)",
        leetcodeSlug: "insert-interval"
    ),
    LeetCodeCard(
        problemNumber: 435,
        title: "Non-overlapping Intervals",
        question: "Find the minimum number of intervals to remove to make the rest non-overlapping.",
        answer: """
        Greedy: sort by end time, keep as many non-overlapping intervals as possible.
        • Sort intervals by end
        • Track the end of the last kept interval
        • For each interval: if it doesn't overlap (start ≥ lastEnd), keep it (update lastEnd); else remove it (increment count)

        Result: n - (count of kept intervals).

        Why sort by end? Keeping intervals that end earliest leaves the most room for future intervals.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.intervals, .array],
        timeComplexity: "O(n log n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "non-overlapping-intervals"
    ),
    LeetCodeCard(
        problemNumber: 252,
        title: "Meeting Rooms",
        question: "Determine if a person can attend all meetings (no overlapping intervals).",
        answer: """
        Sort intervals by start time. Check if any adjacent pair overlaps (intervals[i].start < intervals[i-1].end).

        If any overlap found → return false. Otherwise → return true.

        Premium problem. Simple warm-up for Meeting Rooms II.
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.intervals],
        timeComplexity: "O(n log n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "meeting-rooms"
    ),
    LeetCodeCard(
        problemNumber: 253,
        title: "Meeting Rooms II",
        question: "Find the minimum number of conference rooms required.",
        answer: """
        Approach A (Min-Heap):
        • Sort intervals by start time
        • Use min-heap of end times (represents occupied rooms)
        • For each meeting: if heap top ≤ meeting start, pop (reuse that room); push meeting end
        • Heap size = rooms in use at any time; track maximum

        Approach B (Separate sorted arrays):
        • Separate start and end times into two sorted arrays
        • Two pointers: if start[i] < end[j], need new room (i++, rooms++); else a room freed (j++, rooms--)

        Both O(n log n). Approach B is cleaner to implement.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.intervals, .heap],
        timeComplexity: "O(n log n)",
        spaceComplexity: "O(n)",
        leetcodeSlug: "meeting-rooms-ii"
    ),
]

// MARK: - LRU Cache (system design favorite)

let systemDesignAlgoCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 146,
        title: "LRU Cache",
        question: "Design a data structure that follows the LRU (Least Recently Used) cache eviction policy with O(1) get and put.",
        answer: """
        Data structure: Hash Map + Doubly Linked List.
        • Map: key → node (O(1) lookup)
        • DLL: maintains access order; head = most recent, tail = least recent

        get(key): if in map, move node to head, return value; else return -1.
        put(key, value):
        • If exists: update value, move to head
        • If not: create node at head, add to map; if over capacity, remove tail node and its map entry

        DLL with dummy head/tail nodes eliminates nil checks.

        This is asked at all 4 target companies — know it cold.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.hashMap, .linkedList],
        timeComplexity: "O(1) get and put",
        spaceComplexity: "O(capacity)",
        leetcodeSlug: "lru-cache"
    ),
]

// MARK: - Strings

let stringCards: [LeetCodeCard] = [
    LeetCodeCard(
        problemNumber: 125,
        title: "Valid Palindrome",
        question: "Check if a string is a palindrome considering only alphanumeric characters.",
        answer: """
        Two pointers from both ends:
        • Skip non-alphanumeric characters on both sides
        • Compare lowercased characters
        • If any mismatch, return false

        Clean Swift: filter by isLetter/isNumber, lowercased(), compare to reversed().

        O(n) time, O(1) space (two-pointer) or O(n) (filter approach — acceptable).
        """,
        difficulty: .easy,
        companies: all4,
        patterns: [.twoPointer, .string],
        timeComplexity: "O(n)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "valid-palindrome"
    ),
    LeetCodeCard(
        problemNumber: 647,
        title: "Palindromic Substrings",
        question: "Count the number of palindromic substrings in a string.",
        answer: """
        Expand around center approach:
        • For each character (and each pair of characters), expand outward while characters match
        • Odd length: center at single char; Even length: center between two chars
        • Count each valid expansion

        Total of 2n-1 center positions, each O(n) expansion → O(n²) overall.

        DP approach: dp[i][j] = true if s[i..j] is palindrome. Same O(n²) complexity, O(n²) space.

        Manacher's algorithm achieves O(n) but is complex — mention it for bonus points.
        """,
        difficulty: .medium,
        companies: metaAirbnb,
        patterns: [.dynamicProgramming, .twoPointer, .string],
        timeComplexity: "O(n²)",
        spaceComplexity: "O(1)",
        leetcodeSlug: "palindromic-substrings"
    ),
    LeetCodeCard(
        problemNumber: 271,
        title: "Encode and Decode Strings",
        question: "Design an algorithm to encode a list of strings to a single string and decode it back.",
        answer: """
        Approach: Length-prefixed encoding.
        • Encode: for each string, prepend "<length>#" then the string content
        • Decode: read until '#' to get length, then read exactly that many characters as the next string

        Why not delimiter-based? Strings can contain any character including the delimiter.
        Why not CSV-style escaping? More complex, length-prefix is simpler and O(n).

        Example: ["hello", "world"] → "5#hello5#world"

        Premium LeetCode problem — common in system design-adjacent questions.
        """,
        difficulty: .medium,
        companies: all4,
        patterns: [.string],
        timeComplexity: "O(n) encode and decode",
        spaceComplexity: "O(n)",
        leetcodeSlug: "encode-and-decode-strings"
    ),
]

// MARK: - All LeetCode Cards

let allLeetCodeCards: [LeetCodeCard] =
    arraysHashingCards +
    twoPointerCards +
    slidingWindowCards +
    binarySearchCards +
    linkedListCards +
    treeCards +
    trieCards +
    heapCards +
    graphCards +
    dpCards +
    intervalCards +
    systemDesignAlgoCards +
    stringCards
