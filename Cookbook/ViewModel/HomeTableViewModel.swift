import Foundation

 class HomeTableViewModel {
    private let service: CookbookService
    var cookbookContents = [CookbookContent]()
    
    init(service: CookbookService) {
        self.service = service
    }
    
    func getCookBookSections(completion: @escaping () -> Void ) {
        Task {
            do {
                let sections = try await service.createCookbookSections()
                cookbookContents = sections.sorted { $0.name < $1.name }
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print(error)
            }
        }
    }
}
