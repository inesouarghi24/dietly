import Foundation
import SwiftUI

struct InfoUserView: View {
    @State private var startingWeight: String = ""
    @State private var targetWeight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var sex: String = "Homme"
    @State private var activityLevel: String = "Modérément actif"
    
    let sexes = ["Homme", "Femme", "Autre"]
    let activityLevels = ["Sédentaire", "Modérément actif", "Très actif"]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Renseignements Utilisateur")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .foregroundColor(Color("TitleColor"))
                    
                    VStack(spacing: 15) {
                        Text("Données personnelles")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray)
                        
                        CustomTextField(placeholder: "Poids actuel (kg)", text: $startingWeight)
                        CustomTextField(placeholder: "Poids cible (kg)", text: $targetWeight)
                        CustomTextField(placeholder: "Taille (cm)", text: $height)
                        CustomTextField(placeholder: "Âge", text: $age)
                        
                        Picker("Sexe", selection: $sex) {
                            ForEach(sexes, id: \.self) { Text($0) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 8)

                    VStack(spacing: 15) {
                        Text("Niveau d'activité physique")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray)
                        
                        Picker("Niveau d'activité", selection: $activityLevel) {
                            ForEach(activityLevels, id: \.self) { Text($0) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 8)
                    
                    Button(action: {
                        saveUserData()
                    }) {
                        Text("Continuer")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 8)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
    
    func saveUserData() {
      
        print("Données de l'utilisateur sauvegardées")
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
                .font(.subheadline)
                .foregroundColor(Color.gray)
            
            TextField("", text: $text)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .keyboardType(.decimalPad)
                .shadow(radius: 5)
        }
        .padding(.vertical, 5)
    }
}

struct InfoUserView_Previews: PreviewProvider {
    static var previews: some View {
        InfoUserView()
            .preferredColorScheme(.light) 
    }
}
