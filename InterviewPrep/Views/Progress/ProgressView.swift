import SwiftUI

struct ProgressTabView: View {
    @EnvironmentObject var store: StudyStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    overallStats
                    categoryBreakdown
                    recentSessions
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }

    // MARK: - Overall Stats

    private var overallStats: some View {
        VStack(spacing: 16) {
            Text("Lifetime Stats")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                StatCard(
                    title: "Sessions",
                    value: "\(store.totalSessions)",
                    icon: "rectangle.stack",
                    color: .blue
                )
                StatCard(
                    title: "Cards Seen",
                    value: "\(store.totalCardsSeen)",
                    icon: "eye",
                    color: .purple
                )
                StatCard(
                    title: "Accuracy",
                    value: store.overallAccuracyString,
                    icon: "target",
                    color: .green
                )
            }
        }
    }

    // MARK: - Category Breakdown

    private var categoryBreakdown: some View {
        VStack(spacing: 12) {
            Text("By Category")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(CardCategory.allCases, id: \.self) { category in
                let stats = store.stats(for: category)
                CategoryProgressRow(category: category, stats: stats)
            }
        }
    }

    // MARK: - Recent Sessions

    private var recentSessions: some View {
        VStack(spacing: 12) {
            Text("Recent Sessions")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if store.recentSessions.isEmpty {
                Text("No sessions yet. Start studying!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(store.recentSessions) { record in
                    SessionRecordRow(record: record)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct CategoryProgressRow: View {
    let category: CardCategory
    let stats: CategoryStats

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.systemImage)
                .font(.headline)
                .foregroundStyle(categoryColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(category.rawValue)
                        .font(.subheadline.weight(.medium))
                    Spacer()
                    Text(stats.accuracyString)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                ProgressView(value: stats.accuracy)
                    .tint(categoryColor)
                Text("\(stats.seen) of \(stats.total) seen")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private var categoryColor: Color {
        switch category {
        case .concept:    return .blue
        case .leetcode:   return .orange
        case .discussion: return .purple
        case .behavioral: return .green
        }
    }
}

struct SessionRecordRow: View {
    let record: SessionRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(record.deckTitle)
                    .font(.subheadline.weight(.medium))
                Text(record.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(record.correct)/\(record.total) correct")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(record.accuracyString)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}
