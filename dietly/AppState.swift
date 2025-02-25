

import Foundation
import HealthKit

class AppState: ObservableObject {
    @Published var isUserLoggedIn: Bool = true // Mettre true pour bypasser la connexion

    func login() {
        isUserLoggedIn = true
    }

    func logout() {
        isUserLoggedIn = false
    }
}
