import Foundation

struct OpenFoodFactsNutriments: Decodable {
    var energy_kcal_100g: Double?
    var proteins_100g: Double?
    var carbohydrates_100g: Double?
    var fat_100g: Double?

    enum CodingKeys: String, CodingKey {
        case energy_kcal_100g = "energy-kcal_100g"
        case proteins_100g = "proteins_100g"
        case carbohydrates_100g = "carbohydrates_100g"
        case fat_100g = "fat_100g"
    }
}

struct OpenFoodFactsProduct: Decodable {
    var product_name: String?
    var nutriments: OpenFoodFactsNutriments?

    enum CodingKeys: String, CodingKey {
        case product_name = "product_name"
        case nutriments = "nutriments"
    }
}
