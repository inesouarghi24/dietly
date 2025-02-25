
import SwiftUI

struct SettingsView: View {
    @State private var selectedTheme: Color = .blue
    @State private var calorieGoal: Double = 2000.0

    var body: some View {
        VStack {
            Text("Personnalisation")
                .font(.headline)
                .padding(.top, 20)

            Text("Sélectionner un thème")
                .font(.title2)
            
            Button(action: {
                selectedTheme = selectedTheme == .blue ? .green : .blue
            }) {
                Text("Changer le thème")
                    .font(.title2)
                    .padding()
                    .background(selectedTheme)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)

            Text("Objectif calorique journalier : \(Int(calorieGoal)) kcal")
                .font(.title2)
            
            Slider(value: $calorieGoal, in: 1000...4000, step: 100)
                .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
