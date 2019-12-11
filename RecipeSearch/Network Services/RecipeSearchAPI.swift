//
//  RecipeSearchAPI.swift
//  RecipeSearch
//
//  Created by Bienbenido Angeles on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
struct RecipeSearchAPI {
    static func fetchRecipe(for searchQuery: String, completion: @escaping (Result<[Recipe], AppError>) ->()){
        
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "tacos"
        let recipeEndPointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appID)&app_key=\(SecretKey.appKey)&from=0&to=50"
        
        //Later we will look at url components and URLQueryItems
        guard let url = URL(string: recipeEndPointURL) else {
            completion(.failure(.badURL(recipeEndPointURL)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let searchResults = try JSONDecoder().decode(RecipeSearch.self, from: data)
                    //TO DO: Use search results to create an array of recipes
                    let recipes = searchResults.hits.map{$0.recipe}
                    //TO DO: Capture the array of recipes in the completion handler
                    completion(.success(recipes))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        
    }
}
