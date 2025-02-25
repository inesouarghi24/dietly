import SwiftUI

struct RepasView: View {
    @State private var scannedFoods: [ScannedFood] = [] // Liste des aliments scannés
    @State private var showingScanner = false
    @State private var totalCalories: Double = 0.0
    @State private var scannedCode: String = ""
    
    var body: some View {
        VStack {
            Text("Ajouter un repas")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("Scanne tes aliments pour les ajouter au repas")
                .font(.headline)
                .padding(.top, 10)
            
            Spacer()

            // Liste des aliments scannés
            List {
                ForEach(scannedFoods.indices, id: \.self) { index in
                    let food = scannedFoods[index]
                    VStack(alignment: .leading) {
                        HStack {
                            Text(food.productName)
                            Spacer()
                            Text("\(food.calories, specifier: "%.0f") kcal")
                        }
                        
                        HStack {
                            TextField("Quantité", text: Binding(
                                get: { String(food.quantity) },
                                set: { newValue in
                                    if let quantity = Double(newValue) {
                                        updateQuantity(for: index, quantity: quantity)
                                    }
                                }
                            ))
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.center)
                            
                            Picker("Unité", selection: Binding(
                                get: { food.unit },
                                set: { newUnit in
                                    updateUnit(for: index, unit: newUnit)
                                }
                            )) {
                                Text("g").tag(Unit.gram)
                                Text("ml").tag(Unit.milliliter)
                                Text("kg").tag(Unit.kilogram)
                                Text("L").tag(Unit.liter)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 100)
                        }
                    }
                }
            }
            
            Spacer()

            // Bouton pour scanner un aliment
            Button(action: {
                showingScanner = true
            }) {
                Text("Scanner un aliment")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
            .sheet(isPresented: $showingScanner) {
                BarcodeScannerView(scannedCode: $scannedCode, isPresenting: $showingScanner)
                    .onDisappear {
                        fetchScannedFoodData(from: scannedCode)
                    }
            }

            // Affichage du total des calories
            Text("Total des calories: \(totalCalories, specifier: "%.0f") kcal")
                .font(.title2)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Repas")
    }

    // Met à jour la quantité pour un aliment et recalcule les calories en fonction de l'unité
    func updateQuantity(for index: Int, quantity: Double) {
        scannedFoods[index].quantity = quantity
        recalculateCalories(for: index)
        calculateTotalCalories()
    }

    // Met à jour l'unité pour un aliment et recalcule les calories
    func updateUnit(for index: Int, unit: Unit) {
        scannedFoods[index].unit = unit
        recalculateCalories(for: index)
        calculateTotalCalories()
    }
    
    // Recalcule les calories en fonction de la quantité et de l'unité
    func recalculateCalories(for index: Int) {
        let food = scannedFoods[index]
        let factor: Double
        switch food.unit {
        case .gram:
            factor = 1.0
        case .milliliter:
            factor = 1.0 // Considéré équivalent pour simplifier
        case .kilogram:
            factor = 1000.0
        case .liter:
            factor = 1000.0 // Considéré équivalent pour simplifier
        }
        scannedFoods[index].calories = (food.quantity * factor / 100) * food.caloriesPer100g
    }
    
    // Recalcule le total des calories pour le repas
    func calculateTotalCalories() {
        totalCalories = scannedFoods.reduce(0) { $0 + $1.calories }
    }
    
    // Récupère les données d'un aliment scanné depuis l'API OpenFoodFacts
    func fetchScannedFoodData(from barcode: String) {
        NetworkManager.fetchProductData(from: barcode) { fetchedProduct in
            guard let product = fetchedProduct else {
                print("Produit non trouvé.")
                return
            }

            DispatchQueue.main.async {
                // Ajoute un nouvel aliment scanné à la liste
                let newFood = ScannedFood(
                    id: UUID(),
                    productName: product.product_name ?? "Inconnu",
                    quantity: 100, // Quantité par défaut
                    caloriesPer100g: product.nutriments?.energy_kcal_100g ?? 0,
                    calories: product.nutriments?.energy_kcal_100g ?? 0, // Par défaut pour 100g
                    unit: .gram // Unité par défaut
                )
                scannedFoods.append(newFood)
                calculateTotalCalories()
            }
        }
    }
}

// Modèle pour un aliment scanné avec une unité
struct ScannedFood: Identifiable {
    let id: UUID
    let productName: String
    var quantity: Double // Quantité
    let caloriesPer100g: Double // Calories pour 100g
    var calories: Double // Calories calculées en fonction de la quantité
    var unit: Unit // Unité choisie
}


enum Unit: String, CaseIterable, Identifiable {
    case gram, milliliter, kilogram, liter
    var id: String { self.rawValue }
}

struct RepasView_Previews: PreviewProvider {
    static var previews: some View {
        RepasView()
    }
}
