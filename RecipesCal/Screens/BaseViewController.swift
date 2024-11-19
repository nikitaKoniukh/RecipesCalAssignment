//
//  BaseViewController.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 19/11/2024.
//

import UIKit

class BaseViewController: UIViewController {
    func showErrorPopup(recipeError: RecipeError) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: recipeError.title, message: recipeError.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
