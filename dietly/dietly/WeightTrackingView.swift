

import SwiftUI

struct WeightTrackingView: View {
    @State private var currentWeight: Double = 70.0 // Poids actuel en kg
    @State private var height: Double = 1.70 
    @State private var bmi: Double = 0.0

    var body: some View {
        VStack {
            Text("Suivi du poids et de l'IMC")
                .font(.headline)
                .padding(.top, 20)

            // Saisie du poids actuel
            Text("Poids actuel : \(String(format: "%.1f", currentWeight)) kg")
                .font(.title2)
            Slider(value: $currentWeight, in: 40...150, step: 0.5)
                .padding()

            // Saisie de la taille
            Text("Taille : \(String(format: "%.2f", height)) m")
                .font(.title2)
            Slider(value: $height, in: 1.40...2.20, step: 0.01)
                .padding()

            // Calcul de l'IMC
            Button(action: {
                calculateBMI()
            }) {
                Text("Calculer l'IMC")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Text("IMC : \(String(format: "%.2f", bmi))")
                .font(.title)
                .padding(.top, 20)
        }
    }

    // Fonction pour calculer l'IMC
    func calculateBMI() {
        bmi = currentWeight / (height * height)
    }
}

struct WeightTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        WeightTrackingView()
    }
}
