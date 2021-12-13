import UIKit

enum RecipeDetailVCSection: String, CaseIterable {
    case instructions
    case ingredients
}

class RecipeDetailsViewController: UIViewController, Storyboarded {
    @IBOutlet weak var recipeDetailsTableView: UITableView!
    @IBOutlet weak var recipeDetailsTableViewHeader: UILabel!
    
    var viewModel: RecipeDetailsViewModel!
    private var dataSource: RecipeDetailsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        recipeDetailsTableView.delegate = self
        viewModel.fetchRecipeDetails {
            self.updateUI()
        }
    }
    
    private func configureDataSource() {
        dataSource = RecipeDetailsDataSource(tableView: recipeDetailsTableView, cellProvider: { tableView, indexPath, recipeDetails in
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeDetailsCell", for: indexPath)
            cell.textLabel?.text = recipeDetails
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        })
    }
    
    private func updateUI() {
        guard let cookbookRecipeDetails = viewModel.recipeDetails?.cookbookRecipeDetails.first else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<RecipeDetailVCSection, String>()
        snapshot.appendSections(RecipeDetailVCSection.allCases)
        snapshot.appendItems([cookbookRecipeDetails.instructions], toSection: .instructions)
        snapshot.appendItems(cookbookRecipeDetails.ingredients, toSection: .ingredients)
        dataSource?.apply(snapshot)
        
        recipeDetailsTableViewHeader.numberOfLines = 0
        recipeDetailsTableViewHeader.lineBreakMode = .byWordWrapping
        recipeDetailsTableViewHeader.text = cookbookRecipeDetails.name
    }
}

extension RecipeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeDetailsTableView.deselectRow(at: indexPath, animated: true)
    }
}

fileprivate class RecipeDetailsDataSource: UITableViewDiffableDataSource<RecipeDetailVCSection, String> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return RecipeDetailVCSection.allCases[section].rawValue.uppercased()
    }
}
