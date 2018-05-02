//
//  Recipe.swift
//  JustEatIt
//
//  Created by Arjun Sarup on 16/04/18.
//  Copyright © 2018 A&N. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    let recipeName: String
    let imageUrl: String
    let recipeID: String
    let missing: Int
    
    init(recipeName: String, imageUrl: String, missing: Int, recipeID: String) {
        self.recipeName = recipeName
        self.imageUrl = imageUrl
        self.missing = missing
        self.recipeID = recipeID
    }
}




