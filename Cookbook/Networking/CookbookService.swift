import Foundation
import UIKit

enum ServiceError: String, Error {
    case noNameOrInstructions
}

struct CookbookService {
    private let networkManager: NetworkManagable
    
    init(networkManger: NetworkManagable) {
        self.networkManager = networkManger
    }
    
    func createCookbookSections() async throws -> [CookbookContent] {
        try await withThrowingTaskGroup(of: CookbookContent.self) { group in
            let categories = try await fetchCategories().categories
            
            for category in categories {
                group.addTask {
                    let meals = try await fetchMeals(with: category.name)
                    let cookbookSection = CookbookContent(name: category.name, meals: meals.recipes)
                    return cookbookSection
                }
            }
            var cookbookSections = [CookbookContent]()
            
            for try await value in group {
                cookbookSections.append(value)
            }
            
            return cookbookSections
        }
    }
    
    func fetchRecipeDetails(with id: String) async throws -> RecipeDetailsResponseWrapper {
        guard let url = constructURL(with: .lookupMeal, query: id) else {
            throw NetworkErrors.InvalidURL
        }
        
        let recipe = try await networkManager.fetchValue(of: RecipeDetailsResponseWrapper.self, for: url)
        
        return recipe
    }
    
    private func fetchCategories() async throws -> MealCategoriesResponse {
        guard let url = constructURL(with: .mealCategories, query: nil) else {
            throw NetworkErrors.InvalidURL
        }
        
        let mealCategories = try await networkManager.fetchValue(of: MealCategoriesResponse.self,
                                                                 for: url)
        return mealCategories
    }
    
    private func fetchMeals(with category: String) async throws -> MealsResponse {
        guard let url = constructURL(with: .meals, query: category) else {
            throw NetworkErrors.InvalidURL
        }
        
        let meals = try await networkManager.fetchValue(of: MealsResponse.self, for: url)
        
        return meals
    }
    
    private func constructURL(with path: Paths, query: String?) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.themealdb.com"
        components.path = "/api/json/v1/1/\(path.rawValue).php"
        
        switch path {
        case .mealCategories:
            break
        case .meals:
            components.queryItems = [
                URLQueryItem(name: "c", value: query)
            ]
        case .lookupMeal:
            components.queryItems = [
                URLQueryItem(name: "i", value: query)
            ]
        }
        
        return components.url
    }
}

enum Paths: String {
    case mealCategories = "categories"
    case meals = "filter"
    case lookupMeal = "lookup"
}
