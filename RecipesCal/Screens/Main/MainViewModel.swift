//
//  MainViewModel.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func recipesFetched()
    func recipesFetchingFailed(with error: Error)
    func encryptionFailed(with error: Error)
    func encryptionFinished(with encryptedData: Data)
}

final class MainViewModel {
    private let recipesStringUrl = "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json"
    weak var delegate: MainViewModelDelegate?
    var recipes: [Recipe]?
    
    func fetchRecipes() {
        APIService.shared.execute(recipesStringUrl, expecting: [Recipe].self, completion: { [weak self] result in
            switch result {
            case .success(let recipes):
                DispatchQueue.main.async {
                    self?.recipes = recipes
                    self?.delegate?.recipesFetched()
                }
            case .failure(let error):
                self?.delegate?.recipesFetchingFailed(with: error)
            }
        })
    }
    
    func encrypt(_ recipe: Recipe) {
        let cryptoManager = RecipeCryptoManager()
        
        do {
            let encryptedData = try cryptoManager.encrypt(recipe: recipe)
            delegate?.encryptionFinished(with: encryptedData)
        } catch {
            print("Error during encryption or decryption: \(error)")
            delegate?.encryptionFailed(with: error)
        }
    }
}
