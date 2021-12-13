import Foundation

struct CookbookContent: Hashable {
    let name: String
    let meals: [Recipe]
}

struct MealCategoriesResponse: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
}

struct MealsResponse: Decodable {
    let recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}

struct Recipe: Codable, Hashable {
    let name: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
    }
}

struct RecipeDetailsResponseWrapper: Decodable {
    let cookbookRecipeDetails: [RecipeDetailsResponse]
    
    enum CodingKeys: String, CodingKey {
        case cookbookRecipeDetails = "meals"
    }
}

struct RecipeDetailsResponse: Decodable, Hashable {
    let name: String
    let instructions: String
    let ingredients: [String]
    
    init(from decoder: Decoder) throws {
        var combinedRecipeDetails = [String]()
        var decodedIngredients = [String?]()
        var decodedMeasurements = [String?]()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        
        for index in 2..<CodingKeys.allCases.count - 1 {
            if CodingKeys.allCases[index].rawValue.hasPrefix("strIngredient") {
                let decodedIngredient = try? container.decode(String.self, forKey: .allCases[index])
                
                if decodedIngredient != nil && decodedIngredient != "", decodedIngredient != " " {
                    decodedIngredients.append(decodedIngredient)
                }
            }
            
            if CodingKeys.allCases[index].rawValue.hasPrefix("strMeasure") {
                let decodedMeasurement = try? container.decode(String.self, forKey: .allCases[index])
                
                if decodedMeasurement != nil, decodedMeasurement != "", decodedMeasurement != " " {
                    decodedMeasurements.append(decodedMeasurement)
                }
            }
        }
        
        
        for index in 0..<decodedMeasurements.count - 1 {
            if let measurement = decodedMeasurements[index], let ingredient = decodedIngredients[index] {
                let combined = "\(measurement) \(ingredient)"
                combinedRecipeDetails.append(combined)
            }
        }
        
        combinedRecipeDetails.removeAll { $0 == "  "}
        ingredients = combinedRecipeDetails
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name = "strMeal"
        case instructions = "strInstructions"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
        case measure16 = "strMeasure16"
        case measure17 = "strMeasure17"
        case measure18 = "strMeasure18"
        case measure19 = "strMeasure19"
        case measure20 = "strMeasure20"
    }
}
