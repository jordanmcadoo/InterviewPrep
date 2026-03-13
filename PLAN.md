# InterviewPrep — App Plan

Native iOS app for senior/staff IC interview prep. Swift + SwiftUI, iOS 17+.

---

## Goals

- Flash cards for Swift/iOS concepts, LeetCode problems, technical discussion, and behavioral questions
- All data hardcoded in-app (no backend)
- LeetCode focus: problems common to Meta, Airbnb, Pinterest, Dropbox
- Company filter built into the data model from day one (easy to expand)
- Spaced repetition and progress tracking over time

---

## Architecture

**Pattern:** MVVM
**Persistence:** UserDefaults (Phase 1–2), SwiftData (Phase 3)
**Min target:** iOS 17

### Data model

```
Card (protocol)
├── ConceptCard       — Swift/iOS concepts, organized by topic
├── LeetCodeCard      — Problem + approach + complexity + company tags
├── DiscussionCard    — Open-ended system design / technical scenarios
└── BehavioralCard    — STAR-format questions with key themes

AnyCard             — Type-erased wrapper for heterogeneous collections
Deck                — Named collection of AnyCards with metadata
CardFilter          — Value type; applies category/difficulty/company/pattern/search filters
StudySession        — ObservableObject; tracks current index + per-card results in-memory
```

### Company tagging

`LeetCodeCard.companies: Set<Company>` — tagged from day one. Adding a new company = add a `Company` enum case + update relevant cards. No structural changes needed.

### App structure

```
TabView
├── Study      — Deck picker → flash card session → completion screen
├── Browse     — Searchable/filterable list of all cards → detail view
└── Progress   — Lifetime stats + per-category breakdown + recent sessions
```

---

## File Structure

```
InterviewPrep/
├── Models/
│   ├── Card.swift              — protocol, enums, concrete card types, AnyCard
│   ├── Deck.swift              — Deck struct + CardFilter
│   └── StudySession.swift      — in-session state (ObservableObject)
├── Data/
│   ├── ConceptCards.swift      — ~55 cards across 9 topics
│   ├── LeetCodeCards.swift     — ~50 Blind 75 problems, company-tagged
│   ├── DiscussionCards.swift   — ~16 system design / technical discussion
│   ├── BehavioralCards.swift   — ~22 senior IC behavioral questions
│   └── AllDecks.swift          — DeckCatalog + Deck factory methods
├── ViewModels/
│   ├── StudyViewModel.swift
│   └── BrowseViewModel.swift
├── Views/
│   ├── MainTabView.swift
│   ├── Study/
│   │   ├── StudyView.swift         — router + ActiveStudyView + CompletionView
│   │   ├── FlashCardView.swift     — flip animation, front/back
│   │   └── DeckPickerView.swift
│   ├── Browse/
│   │   ├── BrowseView.swift        — search + filter sheet
│   │   └── CardDetailView.swift    — reveal answer, complexity, tags, companies
│   └── Progress/
│       └── ProgressView.swift
└── Persistence/
    └── StudyStore.swift        — session records in UserDefaults
```

---

## Content Sources

| Category | Sources |
|---|---|
| Swift/iOS concepts | HackingWithSwift career guide + 150 interview questions, Apple Developer Docs |
| LeetCode | Blind 75 list, company tags from known interview data |
| Technical discussion | iOS Interview Guide (iosinterviewguide.com), themobileinterview.com, mobile-system-design GitHub |
| Behavioral | Standard senior/staff IC rubrics |

---

## Build Phases

### Phase 1 — Core MVP ✅ Done
- [x] All data models
- [x] Full hardcoded content (concepts, LeetCode, discussion, behavioral)
- [x] Flash card UI with flip animation + swipe gestures
- [x] Deck picker (pre-built decks + company-specific LeetCode decks)
- [x] Session completion screen with stats + review missed cards
- [x] Basic session progress tracking (in-memory)
- [x] Browse tab with search and filter sheet
- [x] Card detail view
- [x] Progress tab with UserDefaults persistence

### Phase 2 — Browse & Filter Polish
- [ ] Algorithm pattern filter in browse (currently supported in model, not exposed in UI)
- [ ] Filter chips / active filter summary visible without opening sheet
- [ ] "Study filtered cards" button in browse → launch a deck from current filter
- [ ] Sort options (by difficulty, by company, by problem number)
- [ ] LeetCode card links to leetcode.com problem

### Phase 3 — Spaced Repetition & Persistence
- [ ] Migrate session storage to SwiftData
- [ ] Per-card history: track correct/incorrect counts across all sessions
- [ ] Spaced repetition scheduling (simple bucket/interval system)
- [ ] "Due for review" deck based on SRS schedule
- [ ] Streak tracking (daily study goal)

### Phase 4 — Polish & Extras
- [ ] Haptics on card swipe and button taps
- [ ] Daily card widget (WidgetKit)
- [ ] iCloud sync via SwiftData + CloudKit
- [ ] Dark mode color tuning
- [ ] Onboarding flow (pick target companies on first launch)
- [ ] Add more content: more LeetCode companies, more concept cards

---

## Expanding to New Companies

1. Add case to `Company` enum in `Card.swift`
2. Tag relevant `LeetCodeCard` entries in `LeetCodeCards.swift` with the new company
3. A company-specific deck appears automatically in `DeckCatalog.companyDecks`
4. The filter sheet in Browse picks it up automatically

No other changes needed.

---

## Key Design Decisions

**Why `AnyCard` instead of `any Card`?**
`any Card` (existential) would box values at runtime and make collections of mixed card types awkward to handle in SwiftUI (no `Hashable`, `Equatable` without extra work). `AnyCard` as an enum gives us a concrete type with full Hashable/Equatable support and exhaustive switch matching.

**Why `StudySession` as `ObservableObject` vs. keeping state in ViewModel?**
The session has its own lifecycle (start, advance, complete, restart) that's cleanly encapsulated. The ViewModel acts as a coordinator that creates/replaces sessions. `ActiveStudyView` observes the session directly — this is what ensures card transitions re-render correctly.

**Why UserDefaults over SwiftData for Phase 1?**
SwiftData adds schema migration complexity and is overkill for a simple array of session records. UserDefaults + Codable is sufficient for now and trivially replaceable in Phase 3.
