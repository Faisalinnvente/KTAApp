//
//  CustomMealsViewController.swift
//  KTA
//
//  Created by qadeem on 21/02/2021.
//

import UIKit

class CustomMealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var customMealsTableView: UITableView!
    @IBOutlet weak var addCustomMealButton: UIButton!
    
    var customMeals: [CustomMeal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func initViews() {
        getCustomMeals()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.getCustomMeals), name: Notification.Name("refreshCustomMeals"), object: nil)
        
        let nib = UINib(nibName: "CustomMealTableViewCell", bundle: nil)
        customMealsTableView.register(nib, forCellReuseIdentifier: "CustomMealTableViewCell")
        customMealsTableView.delegate = self
        customMealsTableView.dataSource = self
    }
    
    @objc func getCustomMeals() {
        self.customMeals = DatabaseManager.getInstance().getAllCustomMeals()
        customMealsTableView.reloadData()
    }

    @IBAction func addCustomMeal(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddCustomMealViewController") as! AddCustomMealViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customMealsTableView.dequeueReusableCell(withIdentifier: "CustomMealTableViewCell", for: indexPath) as! CustomMealTableViewCell

        cell.configureCell(customMeal: customMeals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "CustomMealsDetailsViewController") as! CustomMealsDetailsViewController
        vc.setData(mealDetails: customMeals[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
