//
//  ActivityPlannerComponents.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//

import SwiftUI

// MARK: - App Style

enum ActivityPlannerStyle {

    static let accent = Color.blue

    static let cardBackground =
        Color(uiColor: .secondarySystemGroupedBackground)

    static let screenBackground =
        Color(uiColor: .systemGroupedBackground)

    static let cardRadius: CGFloat = 22
    static let searchRadius: CGFloat = 18

    static let cardShadow = Color.black.opacity(0.035)

    static let heroGradient = LinearGradient(
        colors: [
            Color(red: 0.12, green: 0.35, blue: 0.72),
            Color(red: 0.24, green: 0.55, blue: 0.88),
            Color(red: 0.48, green: 0.72, blue: 0.94)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Card Style

struct ActivityPlannerCardModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(18)
            .background(ActivityPlannerStyle.cardBackground)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: ActivityPlannerStyle.cardRadius
                )
            )
            .shadow(
                color: ActivityPlannerStyle.cardShadow,
                radius: 12,
                x: 0,
                y: 5
            )
    }
}

extension View {
    func activityPlannerCard() -> some View {
        modifier(ActivityPlannerCardModifier())
    }
}

// MARK: - Home Hero

struct HomeHeroView: View {

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ActivityPlannerStyle.heroGradient

            Circle()
                .fill(.white.opacity(0.10))
                .frame(width: 180, height: 180)
                .offset(x: 65, y: -65)

            Image(systemName: "sun.max.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow.opacity(0.9))
                .offset(x: -30, y: 100)

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "location.north.circle.fill")

                    Text("ActivityPlanner")
                        .font(.title2.bold())

                    Spacer()

                    Image(systemName: "cloud.sun.fill")
                        .font(.title)
                }

                Spacer()

                Text("Plan your next\nadventure.")
                    .font(.system(size: 32, weight: .bold))

                Text("Discover the best days for the activities you love.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))

                Label(
                    "7-day activity outlook",
                    systemImage: "calendar"
                )
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white.opacity(0.18))
                .clipShape(Capsule())
            }
            .foregroundStyle(.white)
            .padding(24)
            .padding(.top, 45)
            .padding(.bottom, 50)
        }
        .frame(height: 260)
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 28,
                bottomTrailingRadius: 28
            )
        )
    }
}

// MARK: - Search Bar

struct ActivityPlannerSearchBar: View {

    @Binding var query: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(ActivityPlannerStyle.accent)

            TextField("Search for a city or town", text: $query)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
                .submitLabel(.search)

            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 56)
        .background(ActivityPlannerStyle.cardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: ActivityPlannerStyle.searchRadius
            )
        )
        .shadow(
            color: .black.opacity(0.07),
            radius: 12,
            x: 0,
            y: 5
        )
    }
}

// MARK: - Section Header

struct ActivityPlannerSectionHeader: View {

    let title: String
    let symbol: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Label(title, systemImage: symbol)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.caption.weight(.semibold))
            }
        }
    }
}

// MARK: - City Row

struct CityRowView: View {

    let city: City

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(ActivityPlannerStyle.accent.opacity(0.10))
                    .frame(width: 46, height: 46)

                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundStyle(ActivityPlannerStyle.accent)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(city.name)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(city.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Empty State

struct ActivityPlannerEmptyState: View {

    let symbol: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 30))
                .foregroundStyle(ActivityPlannerStyle.accent.opacity(0.7))

            Text(title)
                .font(.subheadline.weight(.semibold))

            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}

// MARK: - Welcome Section

struct HomeWelcomeView: View {

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 46))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.orange, .blue.opacity(0.6))

            Text("Your next adventure starts here")
                .font(.headline)

            Text(
                "Search for a city to discover the best days for skiing, surfing and sightseeing."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 30)
        .padding(.top, 18)
    }
}
