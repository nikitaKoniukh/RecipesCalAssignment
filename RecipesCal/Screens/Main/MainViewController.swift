//
//  MainViewController.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerTableViewCells()
        setupViewModel()
    }
    
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchRecipes()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func registerTableViewCells() {
        let cells: [Identifiable.Type] = [RecipeTableViewCell.self]
        
        cells.forEach {
            tableView.register($0.nib, forCellReuseIdentifier: $0.identifier)
        }
    }
    
    private func navigateToDetailScreen(with data: Data) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        guard let detailViewController = storyboard.instantiateInitialViewController() as? DetailViewController else {
            return
        }
        
        let viewModel = DetailViewModel(encryptedRecipeData: data)
        detailViewController.viewModel = viewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: MainViewModelDelegate {
    func encryptionFailed(with error: any Error) {
        
    }
    
    func encryptionFinished(with encryptedData: Data) {
        navigateToDetailScreen(with: encryptedData)
    }
    
    
    func recipesFetched() {
        tableView.reloadData()
    }
    
    func recipesFetchingFailed(with error: any Error) {
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as? RecipeTableViewCell
        let recipe = viewModel.recipes?[indexPath.row]
        let viewModel = RecipeTableViewCellViewModel(recipe: recipe)
        cell?.configure(with: viewModel)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let recipe = viewModel.recipes?[indexPath.row] {
            viewModel.encrypt(recipe)
        }
    }
}
