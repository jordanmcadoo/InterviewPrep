import Foundation

let allBehavioralCards: [BehavioralCard] = [

    // MARK: - Technical Decision Making

    BehavioralCard(
        question: "Tell me about a time you made a difficult technical decision with incomplete information.",
        answer: """
        Key themes to hit (STAR):
        • What was at stake (user impact, deadlines, technical debt)
        • How you gathered enough signal despite incomplete info (timeboxed spike, data analysis, expert input)
        • How you framed the trade-offs for stakeholders
        • The decision process (reversible? make it fast; irreversible? be careful)
        • Outcome and what you'd do differently

        Senior/Staff angle: show that you didn't get paralyzed. Describe your mental model for "good enough" decisions and how you built in reversibility or monitoring.
        """,
        difficulty: .hard
    ),
    BehavioralCard(
        question: "Describe a project where you had to balance shipping new features against paying down technical debt.",
        answer: """
        Key themes:
        • How you quantified the cost of the debt (slow development, bugs, oncall burden)
        • How you made the case to product/leadership using business language (not engineering jargon)
        • The negotiation: 20% time, dedicated sprint, bundling refactor with related feature
        • How you tracked and demonstrated the outcome (velocity metrics, incident reduction)

        Avoid: framing it as "I convinced them to let me do the right thing." Frame it as collaborative problem-solving with shared business goals.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "Tell me about the most complex technical system you've designed.",
        answer: """
        Key themes:
        • Set the context: scale, constraints, team size
        • Walk through your design process: requirements → high-level design → key trade-off decisions
        • Specific technical choices and why (push vs. pull, eventual vs. strong consistency, etc.)
        • What you'd do differently in hindsight
        • Impact: latency, reliability, team productivity

        Staff angle: mention how you involved others, documented the design, gained alignment, and enabled the team to build on it independently.
        """,
        difficulty: .hard
    ),
    BehavioralCard(
        question: "Tell me about a time you shipped something that caused a production incident.",
        answer: """
        Key themes (the 5 I's framework):
        1. Identify: how did you detect it? (alerts, user reports, monitoring)
        2. Impact: what was the user/business impact?
        3. Investigate: how did you diagnose root cause under pressure?
        4. Intervene: how did you mitigate/fix (rollback, hotfix, flag)?
        5. Improve: what systemic changes came from the post-mortem?

        Senior take: own the mistake clearly. Show blameless post-mortem thinking. Demonstrate what process improvements you drove. Interviewers want to see self-awareness and growth, not perfection.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "How have you improved engineering processes on your team?",
        answer: """
        Key themes:
        • Identify a pain point with data (slow builds, flaky tests, toil, PR cycle time)
        • How you built consensus for the change (not just implementing it unilaterally)
        • The rollout strategy: pilot with one team, iterate, expand
        • Measurable outcome: time saved, defect rate, team satisfaction

        Examples: code review standards, automated testing, on-call runbooks, deployment pipelines, pairing practices, ADRs (Architecture Decision Records).

        Staff angle: processes you influenced across multiple teams or drove org-wide adoption.
        """,
        difficulty: .medium
    ),

    // MARK: - Influence & Leadership

    BehavioralCard(
        question: "How have you influenced technical direction without direct authority?",
        answer: """
        Key themes:
        • The problem or opportunity you identified
        • How you built the case (data, prototypes, pilot, writing an RFC)
        • Who you needed to align (engineers, tech leads, product, infra)
        • Navigating disagreement respectfully — finding common ground
        • The outcome and how you maintained momentum after initial buy-in

        This is a core Staff+ question. Frame it as "influence through trust and evidence," not "I was right and convinced everyone else." Showing humility about where you incorporated others' feedback is powerful.
        """,
        difficulty: .hard
    ),
    BehavioralCard(
        question: "Tell me about a time you had to push back on a request from a stakeholder.",
        answer: """
        Key themes:
        • What the request was and why you had concerns (technical risk, user harm, timeline, scope)
        • How you framed the pushback: alternative proposal, not just "no"
        • Listening to understand their actual goal (often different from the stated ask)
        • The negotiation and outcome — did you fully push back or find middle ground?

        Important: show respect for the stakeholder's perspective. Avoid coming across as dismissive. The best pushbacks reframe the problem, not just reject the solution.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "Describe a time you drove a cross-functional initiative.",
        answer: """
        Key themes:
        • The initiative and why it required cross-functional collaboration
        • How you aligned different teams with different priorities
        • Coordination mechanisms: kickoff meetings, shared docs, Slack channels, status updates
        • How you handled blockers and kept momentum
        • The outcome and what you'd do differently

        Staff angle: show that you can operate at the intersection of engineering, product, design, and data — and that you take ownership of outcomes, not just tasks.
        """,
        difficulty: .hard
    ),
    BehavioralCard(
        question: "How have you handled a disagreement with a product manager about feature scope?",
        answer: """
        Key themes:
        • The specific disagreement: scope, timeline, technical approach, user impact
        • How you raised it: private conversation first, bringing data
        • How you listened to understand the PM's constraints (launch date, user request, exec pressure)
        • The resolution: compromise, phased delivery, escalation if needed
        • The relationship after — did you maintain trust?

        Avoid: "I was right and had to convince them." Instead: "We had different information and priorities — here's how we found common ground."
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "Tell me about a time you mentored a junior engineer.",
        answer: """
        Key themes:
        • How you identified what kind of support they needed (skill gap vs. confidence vs. context)
        • Your approach: pair programming, regular 1:1s, code review as teaching, giving ownership of bounded problems
        • How you calibrated — pushing them to grow without setting them up to fail
        • The outcome: what did they accomplish? What did you learn from mentoring?

        Senior angle: connect this to team health and scalability. A senior engineer who makes the people around them better multiplies their own impact.
        """,
        difficulty: .medium
    ),

    // MARK: - Problem Solving Under Pressure

    BehavioralCard(
        question: "Tell me about a time you had to learn a new technology quickly.",
        answer: """
        Key themes:
        • What forced the learning (new project, tech migration, team need)
        • Your learning strategy: official docs, tutorials, building a toy project, pairing with an expert
        • How you knew when you were ready to apply it in production
        • How you shared learnings with the team

        Strong answer: shows intentionality in learning approach (not just "I read a tutorial"). Mention how you managed the transition period before you were fully proficient.
        """,
        difficulty: .easy
    ),
    BehavioralCard(
        question: "How have you handled situations where requirements changed significantly mid-development?",
        answer: """
        Key themes:
        • What changed and why (pivot, new information, stakeholder shift)
        • How you assessed impact quickly (what's salvageable, what needs to change)
        • Communication: proactive update to stakeholders with options and trade-offs
        • Execution: adapting the plan without complete thrash
        • What you'd do up front next time (flexibility built into architecture, phased delivery)

        Mature answer: shows equanimity under change, not frustration. Requirements change — how you adapt matters more than that it happened.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "Tell me about a time you failed. What did you learn?",
        answer: """
        Key themes:
        • Be specific — don't pick something trivially small or obviously manufactured
        • Own it genuinely: what was your role in the failure?
        • The impact (without catastrophizing)
        • What you learned and specifically changed afterward
        • Evidence that the change stuck

        This is one of the most important questions. Interviewers are evaluating: self-awareness, growth mindset, and whether you can separate your identity from your mistakes. A specific, honest answer beats a vague non-answer every time.
        """,
        difficulty: .hard
    ),
    BehavioralCard(
        question: "How do you prioritize when you have multiple competing deadlines?",
        answer: """
        Key themes:
        • Framework: impact × urgency × stakeholder alignment
        • How you surface conflicts early and get explicit stakeholder input on priority
        • Communication: proactively update all parties, not just the highest-priority one
        • Delegation and unblocking others when you're the bottleneck
        • Saying no or deprioritizing explicitly, not just silently

        Strong answer: shows systematic thinking, not just "I worked harder." Also mention how you protect focus time to avoid constant context-switching.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "Tell me about a time you dealt with significant ambiguity.",
        answer: """
        Key themes:
        • What was ambiguous: problem definition, success criteria, technical approach, team ownership
        • How you reduced ambiguity: asking questions, writing a problem statement and getting feedback, running a spike
        • How you moved forward without full clarity (bias toward action, reversible first steps)
        • The outcome and how you brought others along

        Staff angle: framing ambiguity as part of the job at senior levels. You're not just executing on clearly-defined tasks — you're responsible for defining them. Show comfort with and skill at that.
        """,
        difficulty: .hard
    ),

    // MARK: - Technical Excellence

    BehavioralCard(
        question: "Tell me about a time you significantly improved app performance.",
        answer: """
        Key themes:
        • What metric was poor: launch time, scroll frame rate, memory, network latency, battery
        • Measurement methodology (Instruments, before/after metrics, synthetic benchmarks)
        • Root cause analysis — what was actually causing the problem?
        • The fix and its trade-offs
        • Impact: quantify with before/after numbers

        Strong answer uses specific numbers ("reduced launch time from 3.2s to 1.1s by deferring X") and shows systematic debugging, not lucky guessing.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "Describe a time you advocated for a better user experience against engineering constraints.",
        answer: """
        Key themes:
        • The UX issue: performance, accessibility, confusing interaction, edge case
        • How you identified it (user research, data, dogfooding, accessibility audit)
        • The engineering constraint you were working against (timeline, complexity, technical debt)
        • How you made the case using user impact language
        • The resolution and outcome

        Shows: user empathy and cross-functional collaboration. Engineers who advocate for users, not just for technical elegance, stand out.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "How do you approach giving difficult feedback to peers?",
        answer: """
        Key themes:
        • Timeliness: address it soon, not months later in a performance review
        • Privacy: in 1:1, not publicly in code review or group meeting
        • Specificity: behavior and impact, not character or intent
        • Curiosity: ask for their perspective first — often there's context you're missing
        • Follow-up: check in after to reinforce positive change

        Framework: SBI (Situation-Behavior-Impact) or "I observed X, it had Y impact, I'm curious about Z."

        The hardest part: people often avoid difficult feedback to preserve comfort. Show that you lean into it because you care about the person and the team's outcomes.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "How do you approach code review at the senior/staff level?",
        answer: """
        Goals: knowledge sharing, quality, consistency, mentoring — not gatekeeping.

        What to look for:
        • Correctness: edge cases, error handling, data races
        • Testability and test coverage
        • Naming and clarity (the next reader matters)
        • Architectural fit: does it belong here? Does it set a bad precedent?
        • Performance: obvious algorithmic issues, main-thread violations

        What NOT to do: style nitpicks that linters should catch, blocking PRs for weeks, demanding your approach over a reasonable alternative.

        Tone: phrase suggestions as questions or suggestions, not commands. "Have you considered X?" vs. "Do it this way."

        At staff level: also review for systemic issues — is this a pattern we should define once, not fix in every PR?
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "Tell me about a project you're most proud of.",
        answer: """
        Key themes:
        • Why it mattered: user impact, technical challenge, team growth
        • Your specific contribution (not just what "we" did)
        • The most interesting technical or organizational challenge
        • The outcome and how you measure success
        • Anything you'd do differently

        This is a chance to showcase your best work. Pick something with genuine technical depth or meaningful impact. Avoid being falsely modest — this is an invitation to sell yourself.
        """,
        difficulty: .easy
    ),
    BehavioralCard(
        question: "How have you contributed to your team's engineering culture?",
        answer: """
        Key themes:
        • Concrete actions: started/improved a practice (retrospectives, design reviews, postmortems, pair programming Fridays)
        • Modeling behavior: code review tone, documentation habits, asking for help publicly
        • Psychological safety: making it okay to raise concerns, ask "dumb" questions, admit mistakes
        • Recognizing others' contributions

        Staff angle: culture is often the highest-leverage thing a staff engineer can influence. Show intentionality — not just "I try to be nice" but specific practices you introduced or championed.
        """,
        difficulty: .medium
    ),
    BehavioralCard(
        question: "How do you approach estimation for complex engineering projects?",
        answer: """
        Key themes:
        • Break it down: decompose into known and unknown components
        • Identify unknowns early (spikes, proofs-of-concept to reduce variance)
        • Three-point estimates: best/likely/worst case with explicit assumptions
        • Buffer for integration, testing, review, and inevitable surprises
        • Track actuals vs. estimates and update in real time

        Anti-patterns to call out: padding secretly without transparency, committing to a number without surfacing risks, not updating estimates when scope changes.

        Strong answer: shows that estimation is a communication tool, not a commitment made under pressure. Discuss how you negotiate scope when estimates are too high.
        """,
        difficulty: .hard
    ),
    BehavioralCard(
        question: "How have you grown technically in the past year?",
        answer: """
        Key themes:
        • Specific skills or knowledge gained (new framework, system design, leadership)
        • How you learned: side projects, conference talks, books, pairing, new job responsibilities
        • How you applied it: a project or problem it helped you solve
        • What's next on your learning roadmap

        Shows: growth mindset and self-direction. Strong candidates have a clear answer here and don't wait for the company to define their development for them.
        """,
        difficulty: .easy
    ),
    BehavioralCard(
        question: "Tell me about a time you had to make a trade-off between a short-term fix and a long-term solution.",
        answer: """
        Key themes:
        • The problem and the two paths (quick hack vs. proper solution)
        • How you assessed urgency vs. importance (customer impact, deadline, technical risk)
        • What you chose and why — both can be right depending on context
        • If you took the short-term fix: did you create a tech debt ticket? Communicate the risk?
        • Long-term outcome: did the debt get paid? Did the hack cause problems?

        Senior insight: the right answer isn't always "I did the right thing long-term." Sometimes the short-term fix was correct given business realities. What matters is the intentionality and communication around the decision.
        """,
        difficulty: .medium
    ),
]
