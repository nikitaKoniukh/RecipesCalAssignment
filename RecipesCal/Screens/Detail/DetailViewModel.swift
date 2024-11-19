//
//  DetailViewModel.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//

import UIKit

protocol DetailViewModelProtocol: AnyObject {
    func decryptionSuccess()
    func decryptionFailure()
}

final class DetailViewModel {
    var encryptedRecipeData: Data?
    var recipe: Recipe?
    weak var delegate: DetailViewModelProtocol?
    
    init(encryptedRecipeData: Data?) {
        self.encryptedRecipeData = encryptedRecipeData
    }
    
    var nameString: String? {
        return recipe?.name
    }
    
    var fatsString: String? {
        if let fats = recipe?.fats {
            return "Fats: \(fats)"
        }
        
        return nil
    }
    
    var caloriesString: String? {
        if let calories = recipe?.calories {
            return "Calories: \(calories)"
        }
        
        return nil
    }
    
    var carbsString: String? {
        if let carbos = recipe?.carbos {
            return "Carbs: \(carbos)"
        }
        
        return nil
    }
    
    var descriptionString: String? {
        return recipe?.description
    }
    
    func setImage(completion: @escaping (UIImage?) -> Void) {
        
        guard let imageUrlString = recipe?.thumb else {
            completion(nil)
            return
        }
        
        ImageLoader.shared.getImage(imageUrlString, completion: { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    completion(image)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(String(describing: error))
                    completion(nil)
                }
            }
        })
    }
    
    func getDecryptedRecipe() {
        guard let encryptedData = encryptedRecipeData else {
            return
        }
        
        let cryptoManager = RecipeCryptoManager()
        cryptoManager.getSymmetricKeyWithBiometricsOrPassword(data: encryptedData,
                                                              prompt: "Authenticate to access your recipes",
                                                              fallbackPrompt: "Enter your passcode") { [weak self] result in
            switch result {
            case .success(let decryptedRecipe):
                DispatchQueue.main.async(execute: { [weak self] in
                    self?.recipe = decryptedRecipe
                    self?.delegate?.decryptionSuccess()
                })
                
            case .failure(let error):
                print("Error during encryption or decryption: \(error)")
                DispatchQueue.main.async(execute: { [weak self] in
                    self?.delegate?.decryptionFailure()
                })
            }
        }
    }
}
