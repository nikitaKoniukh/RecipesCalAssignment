//
//  DetailViewController.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//

import UIKit

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var curtainView: UIView!
    
    var viewModel: DetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        curtainView.isHidden = false
        viewModel?.delegate = self
        viewModel?.getDecryptedRecipe()
    }
    
    private func setupData() {
        nameLabel.text = viewModel?.nameString
        fatsLabel.text = viewModel?.fatsString
        carbsLabel.text = viewModel?.carbsString
        caloriesLabel.text = viewModel?.caloriesString
        descriptionLabel.text = viewModel?.descriptionString
        viewModel?.setImage(completion: { [weak self] image in
            self?.thumbnailImageView.image = image
        })
    }
}

extension DetailViewController: DetailViewModelProtocol {
    func decryptionSuccess() {
        setupData()
        curtainView.isHidden = true
    }
    
    func decryptionFailure() {
        showErrorPopup(recipeError: .decryptionError)
        navigationController?.popViewController(animated: true)
    }
}
