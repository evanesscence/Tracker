import Foundation

typealias Binding<T> = (T) -> Void

final class CategoriesViewModel {
    weak var delegate: TrackerCategoryStoreDelegate?
    private var categoryStore: TrackerCategoryStore
    
    private(set) var categories: [CategoryViewModel] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    private(set) var selectedCategory: CategoryViewModel? = nil {
        didSet {
            selectedCategoryBinding?(selectedCategory)
        }
    }
    
    var categoriesBinding: Binding<[CategoryViewModel]>?
    var selectedCategoryBinding: Binding<CategoryViewModel?>?

    init(categoryStore: TrackerCategoryStore, selectedCategory: CategoryViewModel? = nil) {
        self.categoryStore = categoryStore
        self.selectedCategory = selectedCategory
        categoryStore.delegate = self
        
        loadCategories()
    }
    
    convenience init(selectedCategory: CategoryViewModel? = nil) {
        self.init(categoryStore: TrackerCategoryStore(), selectedCategory: selectedCategory)
    }
    
    func loadCategories() {
        categories = getCategoriesFromStore()

    }
    
    func getCategoriesFromStore() -> [CategoryViewModel] {
        categoryStore.trackersCD.map {
            guard let name = $0.name else { fatalError() }
            return CategoryViewModel(
                id: $0.objectID.uriRepresentation().absoluteString,
                name: name
            )
        }
    }
    
    func addNewCategory(category: TrackerCategory) {
        try? categoryStore.addNewCategory(category)
    }
    
    func editCategory(oldCategoryName: String, newCategoryName: String) {
        try? categoryStore.editCategory(oldCategoryName: oldCategoryName, newCategoryName: newCategoryName)
    }
    
    func selectCategory(category: CategoryViewModel) {
        selectedCategory = category
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore, with insertedIndex: IndexSet) {
        loadCategories()
    }
}
