//
//  IngredientsTableViewController.swift
//  JustEatIt
//
//  Created by Arjun Sarup on 18/04/18.
//  Copyright © 2018 A&N. All rights reserved.
//

import UIKit
import SwiftyJSON
import TagListView

class IngredientsTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredient: UILabel!
    
}

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TagListViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func GoButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToResults", sender: nil)
    }
    @IBOutlet weak var IngredientTags: TagListView!
    
    var cellHeight: CGFloat = 85
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IngredientTags.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        IngredientTags.textFont = UIFont.systemFont(ofSize: 16)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewResizerOnKeyboardShown()
        IngredientTags.removeAllTags()
        ingredientNames = []
        tableView.reloadData()
    }
    
    var ingredientNames: [String] = []
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredientNames.count
    }
    
    func getIngredients(_ input: String) {
        let session: URLSession = .shared
        ingredientNames = []
        input.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "https://trackapi.nutritionix.com/v2/search/instant?query=\(input)") {
        var request = URLRequest(url: url)
        request.addValue("b517c761", forHTTPHeaderField: "x-app-id")
        request.addValue("84a7d4eba60a8530fc6f9b6c70bdba55", forHTTPHeaderField: "x-app-key")
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error == nil {
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                let jsonSwifty = try! JSON(data: data)
                let commonNames = jsonSwifty["common"]
                for name in commonNames.arrayValue {
                    if let ingredientN = name["food_name"].string {
                        self.ingredientNames.append(ingredientN)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }}
        })
        task.resume()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientsTableViewCell {
            cell.ingredient.text = ingredientNames[indexPath.row]
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var checker = false
        for s in selectedIngredients {
            if ingredientNames[indexPath.row] == s {
                checker = true
            }
        }
        if !checker {
            selectedIngredients.append(ingredientNames[indexPath.row].replacingOccurrences(of: " ", with: "+"))
            print(selectedIngredients) //For debugging
        
            var tagName: String = ingredientNames[indexPath.row]
            IngredientTags.addTag(tagName).onTap = { [weak self] tagView in
            self?.IngredientTags.removeTagView(tagView)
                selectedIngredients = selectedIngredients.filter{$0 != tagView.currentTitle}
            }
        }
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Call this method somewhere in your view controller setup code.
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Invoked so we can prepare for a change in selection.
        // Remove previous selection, if any.
        if let selectedIndex = self.tableView.indexPathForSelectedRow {
            // Note: Programmatically deslecting does NOT invoke tableView(:didSelectRowAt:), so no risk of infinite loop.
            self.tableView.deselectRow(at: selectedIndex, animated: false)
            // Remove the visual selection indication.
            self.tableView.cellForRow(at: selectedIndex)?.accessoryType = .none
        }
        return indexPath
    }
    
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //setupViewResizerOnViewDisappear()
        self.view.endEditing(true)
    }
    func setupViewResizerOnViewDisappear() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
}

extension IngredientsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let formattedText = searchText.replacingOccurrences(of: " ", with: "+")
        getIngredients(formattedText)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "segueToResults", sender: nil)
        searchBar.text = nil
    }
    
    

}
