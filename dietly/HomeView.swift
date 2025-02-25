import SwiftUI
import AVFoundation
import HealthKit

struct HomeView: View {
    @State private var currentUser: User? = nil
    @State private var totalLipids: Double = 0.0
    @State private var totalProteins: Double = 0.0
    @State private var totalCarbs: Double = 0.0
    @State private var totalCalories: Double = 0.0
    @State private var waterIntake: Double = 0.0
    @State private var calorieGoal: Double = 2000
    @State private var imc: Double = 0.0 

    @State private var scannedBarcode: String = ""
    @State private var product: OpenFoodFactsProduct?
    @State private var isShowingScanner = false

    @State private var totalCaloriesBurned: Double = 0.0
    @State private var netCalories: Double = 0.0

    let healthStore = HKHealthStore()

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Header avec les boutons
                        HStack {
                            NavigationLink(destination: RemindersView()) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.white)
                                    Text("Rappels")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }

                            Spacer()

                            NavigationLink(destination: PhysicalActivityView()) {
                                HStack {
                                    Image(systemName: "figure.walk")
                                        .foregroundColor(.white)
                                    Text("Activité")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                        .padding(.horizontal)

                        // Barre de progression pour l'eau
                        VStack(spacing: 10) {
                            Text("Hydratation")
                                .font(.headline)

                            ProgressBar(value: waterIntake / 2.0) // 2 litres comme objectif
                                .frame(height: 20)
                                .padding(.horizontal)

                            HStack {
                                Text("\(waterIntake, specifier: "%.2f") L sur 2 L")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                // Bouton pour ajouter de l'eau
                                Button(action: {
                                    addWater()
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.blue)
                                        Text("Ajouter")
                                            .font(.footnote)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                        }

                        // Résumé nutritionnel
                        VStack(alignment: .leading, spacing: 15) {
                            Text("RÉSUMÉ NUTRITIONNEL")
                                .font(.headline)
                                .foregroundColor(.gray)

                            HStack(spacing: 40) {
                                // Cercle pour la progression des calories de la journée
                                VStack {
                                    CircleProgressBar(value: totalCalories / calorieGoal)
                                        .frame(width: 150, height: 150)
                                    Text("Calories consommées")
                                        .font(.footnote)
                                    Text("\(totalCalories, specifier: "%.0f") / \(calorieGoal, specifier: "%.0f") kcal")
                                        .font(.footnote)
                                }

                                // Affichage des calories nettes
                                VStack {
                                    Text("Calories nettes")
                                        .font(.headline)
                                    Text("\(netCalories, specifier: "%.0f") kcal")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)

                                    // Calculer les calories nettes
                                    Button(action: {
                                        calculateNetCalories()
                                    }) {
                                        Text("Mettre à jour")
                                            .font(.footnote)
                                            .foregroundColor(.blue)
                                            .padding(.top, 5)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        }

                        // Affichage des informations nutritionnelles après le scan
                        if let product = product {
                            VStack(alignment: .leading) {
                                Text("Nom du produit: \(product.product_name ?? "Inconnu")")
                                if let nutriments = product.nutriments {
                                    Text("Calories (100g): \(nutriments.energy_kcal_100g ?? 0) kcal")
                                    Text("Protéines (100g): \(nutriments.proteins_100g ?? 0) g")
                                    Text("Glucides (100g): \(nutriments.carbohydrates_100g ?? 0) g")
                                    Text("Lipides (100g): \(nutriments.fat_100g ?? 0) g")
                                } else {
                                    Text("Pas d'informations nutritionnelles disponibles.")
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                }

                // Barre de boutons fixe en bas
                VStack {
                    Divider()
                    HStack(spacing: 30) {
                        NavigationLink(destination: RepasView()) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                                Text("Repas")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }

                        // Bouton scanner
                        Button(action: {
                            requestCameraAccess() // Demander l'accès à la caméra
                            isShowingScanner = true
                        }) {
                            Image(systemName: "barcode.viewfinder")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .padding()
                        }
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                        NavigationLink(destination: HistoriqueView()) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .font(.title)
                                    .foregroundColor(.purple)
                                Text("Historique")
                                    .fontWeight(.bold)
                                    .foregroundColor(.purple)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .shadow(radius: 10)
                }
                .background(Color(.systemBackground))
            }
            .onAppear {
                loadCurrentUserData()
                requestHealthKitPermission()
            }
            .navigationTitle("Accueil")
            .sheet(isPresented: $isShowingScanner) {
                ScanView(scannedBarcode: $scannedBarcode)
                    .onDisappear {
                        scanProduct()
                    }
            }
        }
    }

    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("Accès à la caméra accordé")
            } else {
                print("Accès à la caméra refusé")
            }
        }
    }

    func loadCurrentUserData() {
        if let user = users.first {
            currentUser = user
            calculateNutritionSummary(for: user)
        }
    }

    func calculateNutritionSummary(for user: User) {
    }

    func scanProduct() {
        print("Scan démarré avec le code-barres : \(scannedBarcode)")
        NetworkManager.fetchProductData(from: scannedBarcode) { fetchedProduct in
            DispatchQueue.main.async {
                self.product = fetchedProduct
            }
        }
    }

    func addWater() {
        if waterIntake < 2.0 {
            withAnimation(.linear) {
                waterIntake += 0.25
            }
        }
    }

    // Demande d'accès à HealthKit
    func requestHealthKitPermission() {
        let typesToShare: Set = [
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        ]
        
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if success {
                print("HealthKit Authorization Granted!")
                fetchHealthData()
            } else {
                print("HealthKit Authorization Failed: \(String(describing: error))")
            }
        }
    }

    func fetchHealthData() {
        let energyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!

        let query = HKStatisticsQuery(quantityType: energyBurnedType, quantitySamplePredicate: nil, options: .cumulativeSum) { query, result, error in
            if let sum = result?.sumQuantity() {
                let calories = sum.doubleValue(for: HKUnit.kilocalorie())
                DispatchQueue.main.async {
                    self.totalCaloriesBurned = calories
                    self.calculateNetCalories()
                }
            }
        }
        healthStore.execute(query)
    }

    // Calcule les calories nettes en - les calories brûlées des calories consommées
    func calculateNetCalories() {
        netCalories = totalCalories - totalCaloriesBurned
    }
}

struct ProgressBar: View {
    var value: Double

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 300, height: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)

            Rectangle()
                .frame(width: CGFloat(value) * 300, height: 20)
                .foregroundColor(.blue)
        }
        .cornerRadius(10)
    }
}

// Cercle de progression des calories
struct CircleProgressBar: View {
    var value: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.green)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(value, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
 
        }
    }
}

