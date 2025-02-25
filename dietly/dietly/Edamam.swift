//
//  Edamam.swift
//  dietly
//
//  Created by Inès Ouarghi on 23/09/2024.
//

import Foundation

struct EdamamResponse: Codable {
    let parsed: [ParsedFood]
}

struct ParsedFood: Codable {
    let food: Food
}

struct Food: Codable {
    let label: String
    let nutrients: Nutrients
}

struct Nutrients: Codable {
    let ENERC_KCAL: Double?
    let PROCNT: Double?
    let FAT: Double?
    let CHOCDF: Double?
}

// Fonction pour récupérer les données via Edamam API
func fetchEdamamData(from query: String, completion: @escaping (Nutrients?) -> Void) {
    let appId = "YOUR_EDAMAM_APP_ID"
    let appKey = "YOUR_EDAMAM_APP_KEY"
    let urlString = "https://api.edamam.com/api/food-database/v2/parser?ingr=\(query)&app_id=\(appId)&app_key=\(appKey)"
    
    guard let url = URL(string: urlString) else {
        print("URL non valide pour Edamam")
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Erreur lors de la requête Edamam : \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("Données non reçues d'Edamam")
            completion(nil)
            return
        }

        do {
            let decodedData = try JSONDecoder().decode(EdamamResponse.self, from: data)
            completion(decodedData.parsed.first?.food.nutrients)
        } catch {
            print("Erreur de décodage des données Edamam : \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}
