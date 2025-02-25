

import Foundation
import SwiftUI
import CoreData

struct ActivityLogView: View {
    @State private var totalCaloriesBurned: Double = 0.0
    @State private var totalDuration: Double = 0.0
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: ActivityLog.entity(), sortDescriptors: []) var activityLogs: FetchedResults<ActivityLog>
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Bilan sportif")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)

                    HStack {
                        ActivitySummaryView(iconName: "flame.fill", label: "Calories brûlées", value: totalCaloriesBurned, unit: "kcal")
                        ActivitySummaryView(iconName: "clock.fill", label: "Durée totale", value: totalDuration, unit: "min")
                    }
                }
                .padding(.horizontal)

                List {
                    ForEach(activityLogs) { log in
                        ActivityRowView(activityType: log.activityType ?? "Inconnu", duration: log.duration, caloriesBurned: log.caloriesBurned, date: log.date ?? Date())
                    }
                }

                Button(action: {
                }) {
                    Text("Ajouter une activité")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Suivi sportif")
            .onAppear {
                calculateActivitySummary()
            }
        }
    }

    func calculateActivitySummary() {
        totalCaloriesBurned = activityLogs.reduce(0) { $0 + $1.caloriesBurned }
        totalDuration = activityLogs.reduce(0) { $0 + $1.duration }
    }
}

struct ActivitySummaryView: View {
    var iconName: String
    var label: String
    var value: Double
    var unit: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text(label)
                        .font(.headline)
                    Text("\(value, specifier: "%.2f") \(unit)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct ActivityRowView: View {
    var activityType: String
    var duration: Double
    var caloriesBurned: Double
    var date: Date

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activityType)
                    .font(.headline)
                Text("\(duration, specifier: "%.2f") minutes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(caloriesBurned, specifier: "%.2f") kcal")
                    .font(.headline)
                Text("\(date, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
