
import Foundation


import SwiftUI
import CoreData

struct UserListView: View {
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)]
    ) var users: FetchedResults<User>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    VStack(alignment: .leading) {
                        Text("Nom d'utilisateur : \(user.username ?? "Inconnu")")
                            .font(.headline)
                        Text("Email : \(user.email ?? "Inconnu")")
                            .font(.subheadline)
                        Text("Poids de départ : \(user.startingWeight, specifier: "%.2f") kg")
                            .font(.subheadline)
                        Text("Poids cible : \(user.targetWeight, specifier: "%.2f") kg")
                            .font(.subheadline)
                    }
                    .padding()
                }
            }
            .navigationTitle("Liste des utilisateurs")
        }
    }
}
