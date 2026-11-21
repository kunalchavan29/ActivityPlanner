//
//  ActivityScoreCard.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import SwiftUI

struct ActivityScoreCard: View {

    let activity: Activity
    let scores: [ActivityScore]
    
    private var bestScore: ActivityScore? {
        scores
            .filter { $0.activity == activity }
            .max { $0.score < $1.score }
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Image(systemName: activity.symbol)
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Text(activity.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            if let bestScore {
                
                Text("\(bestScore.score)")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(bestScore.rating.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(bestScore.date.formatted(
                    date: .abbreviated,
                    time: .omitted
                ))
                .font(.caption)
                .foregroundStyle(.secondary)
                
            } else {
                
                Text("No data")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
