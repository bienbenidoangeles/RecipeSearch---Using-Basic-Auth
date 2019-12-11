//
//  RecipeSearchController.swift
//  RecipeSearch
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeSearchController: UIViewController {
    
    //TODO: Tableview
    @IBOutlet weak var tableView: UITableView!
    
    //TODO: recipes array
    //TODO: on recipes array, use didSet to update the tableView
    var recipes = [Recipe](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadData()
    }
    
    //TODO: RecipesAPI.fetchRecipes("christmass cookies") {...} to access data to populate recipes array e.g "christmas cookies"
    
    func loadData(){
        RecipeSearchAPI.fetchRecipe(for: "christmas cookie", completion: { (result) in
            switch result{
            case .failure(let appError):
                print("error: \(appError)")
            case .success(let recipe):
                self.recipes = recipe
            }
        })
    }
}

extension RecipeSearchController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    //TODO: in cellForRow, show the recipes label
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.label
        return cell
    }
}
