import Foundation

class RecipesTableViewModel {
    let recipes: [Recipe]
    
    init(recipes: [Recipe]) {
        self.recipes = recipes.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
