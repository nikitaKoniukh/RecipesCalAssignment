//
//  RecipeTableViewCell.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//

import UIKit

final class RecipeTableViewCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: RecipeTableViewCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    public func configure(with viewModel: RecipeTableViewCellViewModel?) {
        self.viewModel = viewModel
        setActivityIndicator()
        setupData()
    }
    
    private func setupData() {
        nameLabel.text = viewModel?.nameString
        fatsLabel.text = viewModel?.fatsString
        carbsLabel.text = viewModel?.carbsString
        caloriesLabel.text = viewModel?.caloriesString
        viewModel?.setImage(completion: { [weak self] image in
            self?.thumbnailImageView.image = image
            self?.activityIndicator.stopAnimating()
        })
    }
    
    private func setActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
}
