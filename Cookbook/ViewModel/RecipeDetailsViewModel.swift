import Foundation

class RecipeDetailsViewModel {
    private let service: CookbookService
    private let recipeId: String
    var recipeDetails: RecipeDetailsResponseWrapper?
    
    init(service: CookbookService, id: String) {
        self.service = service
        self.recipeId = id
    }
    
    func fetchRecipeDetails(completion: @escaping () -> Void) {
        Task {
            do {
                let recipeDetailsResponse = try await service.fetchRecipeDetails(with: recipeId)
                recipeDetails = recipeDetailsResponse
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print(error)
            }
            
        }
    }
}
