//
//  ScoreIndicatorView.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import SwiftUI

struct ScoreIndicatorView: View {
    let score: Int

    private var progress: Double {
        Double(score) / 100
    }

    private var scoreColor: Color {
        switch score {
        case 80...100:
            return .green
        case 60..<80:
            return .blue
        case 40..<60:
            return .orange
        case 20..<40:
            return .red
        default:
            return .gray
        }
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack(alignment: .firstTextBaseline) {

                Text("\(score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(scoreColor)

                Text("/ 100")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geometry in

                ZStack(alignment: .leading) {

                    Capsule()
                        .fill(Color.gray.opacity(0.2))

                    Capsule()
                        .fill(scoreColor)
                        .frame(
                            width: geometry.size.width * progress
                        )
                }
            }
            .frame(height: 7)
        }
    }
}
