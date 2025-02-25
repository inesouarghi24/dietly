
import SwiftUI

struct PhysicalActivityView: View {
    @State private var activityType = "Course"
    @State private var duration: Double = 30 // Durée en minutes
    @State private var caloriesBurned: Double = 0

    let activityOptions = ["Course", "Marche", "Cyclisme", "Natation"]

    var body: some View {
        VStack {
            Text("Suivi de l'activité physique")
                .font(.headline)
                .padding(.top, 20)

            // Sélection de l'activité
            Picker("Activité", selection: $activityType) {
                ForEach(activityOptions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Durée de l'activité
            Text("Durée de l'activité : \(Int(duration)) minutes")
            Slider(value: $duration, in: 10...120, step: 10)
                .padding()

            // Calcul des calories brûlées
            Button(action: {
                calculateCaloriesBurned()
            }) {
                Text("Calculer les calories brûlées")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Text("Calories brûlées : \(Int(caloriesBurned)) kcal")
                .font(.title)
                .padding(.top, 20)
        }
    }

    // Fonction pour calculer les calories brûlées
    func calculateCaloriesBurned() {
        let caloriesPerMinute: Double

        switch activityType {
        case "Course":
            caloriesPerMinute = 10
        case "Marche":
            caloriesPerMinute = 4
        case "Cyclisme":
            caloriesPerMinute = 8
        case "Natation":
            caloriesPerMinute = 7
        default:
            caloriesPerMinute = 5
        }

        caloriesBurned = caloriesPerMinute * duration
    }
}

struct PhysicalActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicalActivityView()
    }
}
