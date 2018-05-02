//
//  ResultsViewController.swift
//  JustEatIt
//
//  Created by Arjun Sarup on 22/04/18.
//  Copyright © 2018 A&N. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var recipeSmolIm: UIImageView!
    @IBOutlet weak var missingIngs: UILabel!
}

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchIngredients()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeName = recipeList[indexPath.row].recipeName
        selectedRecipe = recipeList[indexPath.row].recipeID
        self.performSegue(withIdentifier: "segueToDisplayedResults", sender: nil)
    }
    
    let cellHeight:CGFloat = 115

    let session: URLSession = .shared
    
    //override func viewDidAppear(_ animated: Bool) {
    //    self.navigationController?.isNavigationBarHidden = true
    //}
    
    //override func viewDidDisappear(_ animated: Bool) {
    //    self.navigationController?.isNavigationBarHidden = false
    //}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func searchIngredients() {
        
        recipeList = []
        recipeIDs = []
        recipeSmolImages = []
        
        var allowedIngredients: String = ""
        for ingredient in selectedIngredients {
            allowedIngredients += "allowedIngredient[]=\(ingredient)&"
        }
        allowedIngredients.removeLast()
        //selectedIngredients = []
        if let url = URL(string: "http://api.yummly.com/v1/api/recipes?_app_id=4fbb1547&_app_key=3f554db7fe589de22441c5fc56761ede&\(allowedIngredients)") {
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            if error == nil {
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                let jsonSwifty = try! JSON(data: data)
                let matches = jsonSwifty["matches"]
                for match in matches.arrayValue {
                    let rID = match["id"].stringValue
                    let imageUrlDict: Dictionary<String, JSON> = match["imageUrlsBySize"].dictionaryValue
                    let imageUrl = imageUrlDict["90"]?.stringValue
                    let recipeN = match["recipeName"].stringValue
                    let ingredients = match["ingredients"].arrayValue
                    var matching: Int = 0
                    for ing in ingredients {
                        for selected in selectedIngredients {
                            if ing.stringValue.range(of: selected) != nil {
                                matching += 1                         }
                        }
                    }
                    let missingIngredients = ingredients.count - matching
                    let r: Recipe = Recipe(recipeName: recipeN, imageUrl: imageUrl!, missing: missingIngredients, recipeID: rID)
                    recipeList.append(r)
                    
                    //{
                        //let url2 = URL(string: imageUrl)
                        //let task2 = self.session.dataTask(with: url2!, completionHandler: {
                            //(data, response, error) -> Void in
                            //if error == nil {
                                //guard let data = data else {
                                    //print("Error: No data to decode")
                                    //return
                                //}
                                //if let image = UIImage(data: data) {
                                   // recipeSmolImages.append(image)
                                //}
                            //}
                            
                           // DispatchQueue.main.async {
                           //     self.ResultstableView.reloadData()
                           // }
                            
                        //}).resume()
                    //}
                    
                }
                DispatchQueue.main.async {
                    self.ResultstableView.reloadData()
                    if(recipeList.count == 0) {
                        let alert = UIAlertController(title: "Yummly API couldn't return any results", message: "Try searching for different recipes", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    } else {
                        recipeList = recipeList.sorted{$0.missing < $1.missing}
                    }
                }
            }
        }).resume()
        }
    }
    
    
    @IBOutlet weak var ResultstableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var recipeImage: UIImage?
        if let cell = ResultstableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ResultsTableViewCell {
            let url2 = URL(string: recipeList[indexPath.row].imageUrl)
            let task2 = self.session.dataTask(with: url2!, completionHandler: {
                (data, response, error) -> Void in
                if error == nil {
                    guard let data = data else {
                        print("Error: No data to decode")
                        return
                    }
                    if let image = UIImage(data: data) {
                        recipeImage = image
                    }
                }
                
                DispatchQueue.main.async {
                    cell.recipeSmolIm.image = recipeImage
                    cell.result.text = recipeList[indexPath.row].recipeName
                    cell.missingIngs.text = "-\(recipeList[indexPath.row].missing) missing ingredients"
                    if recipeList[indexPath.row].missing == 0 {
                        cell.missingIngs.text = "0 missing ingredients!"
                    }
                }
                
            }).resume()
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResultstableView.delegate = self
        ResultstableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            selectedIngredients = []
        }
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
