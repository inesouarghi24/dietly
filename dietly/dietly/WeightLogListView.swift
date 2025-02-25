
import Foundation
import SwiftUI
import CoreData

struct WeightLogListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var weightLogs: FetchedResults<WeightLog>

    init(user: User) {
        _weightLogs = FetchRequest(
            entity: WeightLog.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \WeightLog.date, ascending: false)],
            predicate: NSPredicate(format: "user == %@", user)
        )
    }

    var body: some View {
        List {
            ForEach(weightLogs, id: \.self) { log in
                VStack(alignment: .leading) {
                    Text("Poids : \(log.currentWeight)")
                    Text("Date : \(log.date!, formatter: dateFormatter)")
                }
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
