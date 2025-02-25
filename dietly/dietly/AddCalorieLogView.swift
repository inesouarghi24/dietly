import SwiftUI
import CoreData

struct AddCalorieLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var calories: String = ""
    @State private var foodItems: String = ""

    var user: User
    var body: some View {
        VStack {
            TextField("Calories consommées", text: $calories)
                .keyboardType(.decimalPad)
                .padding()
                .border(Color.gray)
            
            TextField("Aliments", text: $foodItems)
                .padding()
                .border(Color.gray)
            
            Button("Ajouter les calories") {
                if let calorieValue = Double(calories) {
                    addCalorieLog(for: user, calories: calorieValue, foodItems: foodItems, context: viewContext)
                    calories = ""
                    foodItems = ""
                }
            }
            .padding()
            .disabled(calories.isEmpty || foodItems.isEmpty)
        }
        .padding()
        .navigationTitle("Ajouter des calories")
    }
}


