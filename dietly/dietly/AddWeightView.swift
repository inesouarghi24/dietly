
import Foundation
import SwiftUI
import CoreData

struct AddWeightView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var currentWeight: String = ""
    var user: User

    var body: some View {
        VStack {
            TextField("Poids actuel", text: $currentWeight)
                .keyboardType(.decimalPad)
                .padding()
                .border(Color.gray)
            
            Button("Ajouter le poids") {
                if let weight = Double(currentWeight) {
                    addWeightLog(for: user, currentWeight: weight, context: viewContext)
                }
            }
            .padding()
        }
        .padding()
    }
}

