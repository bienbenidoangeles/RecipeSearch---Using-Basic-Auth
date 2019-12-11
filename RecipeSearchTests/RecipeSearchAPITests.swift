//
//  RecipeSearchAPITests.swift
//  RecipeSearchTests
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
@testable import RecipeSearch

//Async test
class RecipeSearchAPITests: XCTestCase {

    func testSearchChristmasCookies(){
        //arrange
        //make this string url friendly
        let searchQuery = "christmass cookies".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let exp = XCTestExpectation(description: "searches found")
        let recipeEndPointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appID)&app_key=\(SecretKey.appKey)&from=0&to=50"
        let request = URLRequest(url: URL(string: recipeEndPointURL)!)
        
        //act
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                XCTFail("App Err: \(appError)")
            case .success(let data):
                exp.fulfill()
                //assert
                XCTAssertGreaterThan(data.count, 800000, "Data should be greater than \(data.count)")
            }
        }
        wait(for: [exp], timeout: 5.0)
        
    }
    
    //TODO: write an async test to validate you do get back 50 recipes for the "christmas cookies" search
    
    func testfetchRecipe(){
        //arrange
        let expectedRecipesCount = 50
        let exp = XCTestExpectation(description: "recipes found")
        let searchQuery = "christmas cookies"
        
        //act
        RecipeSearchAPI.fetchRecipe(for: searchQuery) { (result) in
            switch result{
            case .failure(let appError):
                XCTFail("error: \(appError)")
            case .success(let recipes):
                exp.fulfill()
                //assert
                XCTAssertEqual(recipes.count, expectedRecipesCount)
            }
        }
        wait(for: [exp], timeout: 5.0)
    }
}
