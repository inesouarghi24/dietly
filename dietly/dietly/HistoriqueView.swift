
import SwiftUI

struct HistoriqueView: View {
    var body: some View {
        VStack {
            Text("Historique des calories sur 7 jours")
                .font(.title)
                .padding()

            List {
                Text("Lundi : 2000 kcal")
                Text("Mardi : 1800 kcal")
                Text("Mercredi : 2200 kcal")
                Text("Jeudi : 1900 kcal")
                Text("Vendredi : 2100 kcal")
                Text("Samedi : 2300 kcal")
                Text("Dimanche : 1700 kcal")
            }
            .padding()
        }
        .navigationTitle("Historique")
    }
}

struct HistoriqueView_Previews: PreviewProvider {
    static var previews: some View {
        HistoriqueView()
    }
}
