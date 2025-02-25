import SwiftUI
import AVFoundation
import HealthKit

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            VStack {
                if appState.isUserLoggedIn {
                    HomeView()
                } else {
                    VStack {
                        Text("Bienvenue dans l'application Dietly")
                            .font(.title)
                            .padding()

                        Button(action: {
                            appState.isUserLoggedIn = true
                        }) {
                            Text("Se connecter")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}
