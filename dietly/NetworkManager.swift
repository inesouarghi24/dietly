import Foundation

class NetworkManager {
   
    static func fetchProductData(from barcode: String, completion: @escaping (OpenFoodFactsProduct?) -> Void) {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        print("URL de la requête : \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("URL non valide")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur lors de la requête : \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Données non reçues")
                completion(nil)
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Données brutes reçues : \(jsonString)")
            }

           
            do {
                let decodedResponse = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
                completion(decodedResponse.product)
            } catch {
                print("Erreur de décodage des données : \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

struct OpenFoodFactsResponse: Decodable {
    let product: OpenFoodFactsProduct
}
