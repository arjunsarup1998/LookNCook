//
//  SelectedIngredientsViewController.swift
//  JustEatIt
//
//  Created by Arjun Sarup on 22/04/18.
//  Copyright © 2018 A&N. All rights reserved.
//

import UIKit

class SelectedIngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectIng: UILabel!
}

class SelectedIngredientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dudetableView: UITableView!
    
    var cellHeight: CGFloat = 85
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedIngredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dudetableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = dudetableView.dequeueReusableCell(withIdentifier: "idk", for: indexPath) as? SelectedIngredientTableViewCell {
            cell.selectIng.text = selectedIngredients[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    @IBAction func searchButton(_ sender: Any) {
        if (selectedIngredients.count == 0) {
            let alert = UIAlertController(title: "Please select an ingredient", message: "Fam I can't do anything if you don't have any ingredients.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            performSegue(withIdentifier: "segueToDisplayedResults", sender: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dudetableView.dataSource = self
        dudetableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedIngredients.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
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
