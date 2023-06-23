//
//  MenuPresenter.swift
//  HSTestTask
//
//  Created by Темирлан Кудайберген on 22.06.2023.
//

import UIKit

protocol MenuPresenterInput: AnyObject {
    func getData()
    func getImage()
    func drinkModel(at index: Int) -> Drink
    func categoryModel(at index: Int) -> String
    func numberOfDrinks() -> Int
    func numberOfCategories() -> Int
    func indexOfCategory(_ category: String) -> Int?
    func firstIndexOfDrink(with category: String) -> Int?
}

protocol MenuPresenterOutput: AnyObject {
    func reloadTableView()
}

class MenuPresenter {
    
//    MARK: Properties
    
    weak var view: MenuPresenterOutput?
    private var drinks: [Drink] = []
    private var images: [UIImage] = []
    private var categories: [String] = []
}

extension MenuPresenter: MenuPresenterInput {
    func firstIndexOfDrink(with category: String) -> Int? {
        return drinks.firstIndex {
            $0.category == category
        }
    }

    func indexOfCategory(_ category: String) -> Int? {
        return categories.firstIndex {
            $0 == category
        }
    }
    
    func numberOfDrinks() -> Int {
        return drinks.count
    }
    
    func drinkModel(at index: Int) -> Drink {
        return drinks[index]
    }
    
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func categoryModel(at index: Int) -> String {
        return categories[index]
    }
    
    func getData() {
        let isInternetAvailable = Reachability.isConnectedToNetwork()
        guard isInternetAvailable else {
            if let drinks = UserDefaultsHelper.getAllDrinks,
               let categories = UserDefaultsHelper.getAllCategories {
                self.drinks = drinks
                self.categories = categories
                view?.reloadTableView()
            }
            return
        }
        NetworkService.shared.getData { [weak self] result in
            switch result {
            case .success(let drinks):
                DispatchQueue.global(qos: .utility).async {
                    guard let self = self else { return }
                    var drinks = drinks
                    
                    for i in 0..<drinks.count {
                        if let thumbString = drinks[i].thumb,
                            let thumbURL = URL(string: thumbString),
                            let data = try? Data(contentsOf: thumbURL) {
                            drinks[i].thumbImageData = data
                        }
                        
                        if let category = drinks[i].category {
                            if !self.categories.contains(category) {
                                self.categories.append(category)
                            }
                        }
                    }
                    
                    self.categories = self.categories.sorted()
                    drinks = drinks.sorted(by: { $0.category! < $1.category! })
                    UserDefaultsHelper.saveAllDrinks(allObjects: drinks)
                    UserDefaultsHelper.saveAllCategories(allObjects: self.categories)
                    DispatchQueue.main.async {
                        self.drinks = drinks
                        self.view?.reloadTableView()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImage() {
        NetworkService.shared.getImage { [weak self] result in
            switch result {
            case .success(let images):
                guard let images = images else { return }
                self?.images.append(images)
            case .failure(let error):
                print(error)
            }
        }
    }
}

