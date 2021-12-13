import Foundation
import UIKit

class MainCoordinator {
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        let homeTableViewController = HomeTableViewController.instantiate()
        homeTableViewController.coordinator = self
        homeTableViewController.viewModel = HomeTableViewModel(service: CookbookService(networkManger: NetworkManager()))
        navigationController.pushViewController(homeTableViewController, animated: false)
    }
    
    func presentRecipes(with recipes: [Recipe]) {
        let recipesTableViewController = RecipesTableViewController.instantiate()
        recipesTableViewController.coordinator = self
        recipesTableViewController.viewModel = RecipesTableViewModel(recipes: recipes)
        navigationController.pushViewController(recipesTableViewController, animated: false)
    }
    
    func presentRecipeDetails(with id: String) {
        let recipeDetailsViewController = RecipeDetailsViewController.instantiate()
        recipeDetailsViewController.viewModel = RecipeDetailsViewModel(service: CookbookService(networkManger: NetworkManager()), id: id)
        navigationController.pushViewController(recipeDetailsViewController, animated: false)
    }
}
