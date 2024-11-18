//
//  RecipeTableViewCellViewModel.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//

import Foundation
import UIKit

final class RecipeTableViewCellViewModel {
    let recipe: Recipe?
    
    init(recipe: Recipe?) {
        self.recipe = recipe
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
    
}
