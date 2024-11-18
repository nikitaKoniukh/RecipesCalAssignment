//
//  DetailViewController.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var viewModel: DetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
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
