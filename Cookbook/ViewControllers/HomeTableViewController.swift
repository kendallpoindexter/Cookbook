import UIKit

class HomeTableViewController: UIViewController, Storyboarded {
    enum Section {
        case main
    }
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeTableViewHeader: UILabel!
    
    weak var coordinator: MainCoordinator?
    var viewModel: HomeTableViewModel!
    
    private var dataSource: UITableViewDiffableDataSource<Section,CookbookContent>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        configureDataSource()
        viewModel.getCookBookSections {
            self.updateUI()
        }
        
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: homeTableView, cellProvider: { tableView, indexPath, content in
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            cell.textLabel?.text = content.name
            return cell
        })
    }
    
    private func updateUI() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, CookbookContent>()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.cookbookContents)
        dataSource?.apply(snapShot)
        
        homeTableViewHeader.text = "Contents"
    }
}

//MARK: - TableView Delegate Methods
extension HomeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTableView.deselectRow(at: indexPath, animated: true)
        let recipes = viewModel.cookbookContents[indexPath.row].meals
        coordinator?.presentRecipes(with: recipes)
    }
}
