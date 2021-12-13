import UIKit

class RecipesTableViewController: UIViewController, Storyboarded {
    enum Section {
        case main
    }
    
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var recipesTableViewHeader: UILabel!
    
    weak var coordinator: MainCoordinator?
    var viewModel: RecipesTableViewModel!
    
    var dataSource: UITableViewDiffableDataSource<Section, Recipe>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        updateUI()
        recipesTableView.delegate = self
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: recipesTableView, cellProvider: { tableView, indexPath, recipe in
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
            cell.textLabel?.text = recipe.name
            return cell
        })
    }
    
    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.recipes)
        dataSource?.apply(snapshot)
        
        recipesTableViewHeader.text = "Recipes"
    }
}

extension RecipesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipesTableView.deselectRow(at: indexPath, animated: true)
        coordinator?.presentRecipeDetails(with: viewModel.recipes[indexPath.row].id)
    }
}
