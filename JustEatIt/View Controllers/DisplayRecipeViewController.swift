//
//  DisplayRecipeViewController.swift
//  JustEatIt
//
//  Created by Arjun Sarup on 4/24/18.
//  Copyright © 2018 A&N. All rights reserved.
//

import UIKit
import SwiftyJSON
import ChameleonFramework

class DisplayRecipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.flatGreen()
        // Do any additional setup after loading the view.
        displayResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var listOfIngredients: UILabel!
    var rImage: UIImage?
    let session: URLSession = .shared
    func displayResult() {
        recipeName.text = selectedRecipeName
        recipeIngredients = []
        let url = URL(string: "http://api.yummly.com/v1/api/recipe/\(selectedRecipe)")
        var request: URLRequest = URLRequest(url: url!)
        request.addValue("4fbb1547", forHTTPHeaderField: "X-Yummly-App-ID")
        request.addValue("3f554db7fe589de22441c5fc56761ede", forHTTPHeaderField: "X-Yummly-App-Key")
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error == nil {
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                let jsonSwifty = try! JSON(data: data)
                let ingName = jsonSwifty["ingredientLines"].arrayValue
                for ing in ingName {
                    if let ingredient = ing.string {
                        recipeIngredients.append(ingredient)
                    }
                }
                
                let imageArr = jsonSwifty["images"].arrayValue
                var largeImageUrl = ""
                for url in imageArr {
                    largeImageUrl = url["hostedLargeUrl"].stringValue
                }
                let url2 = URL(string: largeImageUrl)
                    let task2 = self.session.dataTask(with: url2!, completionHandler: {
                        (data, response, error) -> Void in
                        if error == nil {
                            guard let data = data else {
                                print("Error: No data to decode")
                                return
                            }
                            self.rImage = UIImage(data: data)
                        }
                        
                        DispatchQueue.main.async {
                            if let image = self.rImage {
                                self.RecipeImage.image = image
                            }
                        }
                        
                    }).resume()
                
                DispatchQueue.main.async {
                    var ings: String = ""
                    for ing in recipeIngredients {
                        ings += " • " + ing + "\n"
                    }
                    self.listOfIngredients.text = ings
                }
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
