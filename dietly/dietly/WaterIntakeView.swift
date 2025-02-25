import SwiftUI

struct WaterIntakeView: View {
    @State private var waterIntake: Int = 0
    @State private var waterGoal: Int = 8 // Objectif quotidien d'hydratation en verres
    @State private var showingGoalAlert = false
    var body: some View {
        VStack {
            HStack {
                Text("Suivi de l'hydratation")
                    .font(.headline)
                    .padding(.top, 20)
                
                Spacer()
                
                // Bouton pour changer l'objectif d'eau
                Button(action: {
                    showingGoalAlert = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 20)
                .alert(isPresented: $showingGoalAlert) {
                    
                    Alert(
                        title: Text("Modifier l'objectif d'eau"),
                        message: Text("Entrez le nombre de verres d'eau que vous souhaitez consommer chaque jour."),
                        primaryButton: .default(Text("OK"), action: {
                            
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding(.horizontal)
            
            Text("Verres d'eau consommés : \(waterIntake)")
                .font(.title2)
            
            ProgressView(value: Double(waterIntake), total: Double(waterGoal))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding()

            Button(action: {
                waterIntake += 1
            }) {
                Text("Ajouter un verre d'eau")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)
        }
        .alert(isPresented: $showingGoalAlert) {
            Alert(
                title: Text("Changer l'objectif d'eau"),
                message: Text("Veuillez entrer votre nouvel objectif de consommation d'eau."),
                primaryButton: .default(Text("Confirmer"), action: {
                    
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

struct WaterIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        WaterIntakeView()
    }
}
