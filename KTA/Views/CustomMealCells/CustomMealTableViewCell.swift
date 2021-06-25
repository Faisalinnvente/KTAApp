//
//  CustomMealTableViewCell.swift
//  KTA
//
//  Created by qadeem on 02/03/2021.
//

import UIKit

class CustomMealTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNutritions: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblServings: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        //nothing
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // for Custom Meals View Controll
    func configureCell(customMeal: CustomMeal) {
        lblName?.text = customMeal.mealName
        lblCalories.text = "\(customMeal.calories) Kcal"
        lblNutritions.text = "Fats • \(customMeal.fats)g Proteins • \(customMeal.protien)g Carbs • \(customMeal.carbs)g"
    }
    
    // for Recent Meals View Controller
    func configureCellForRecentMeals(recentMeal: MealTracking) {
        lblName?.text = recentMeal.mealName
        lblServings.text = "\(recentMeal.servings) servings"
        
        let cals = recentMeal.calories * recentMeal.servings
        lblCalories.text =  "\(cals) kcal"
        
        lblNutritions.text = "Fats • \(recentMeal.fats)g Proteins • \(recentMeal.protien)g Carbs • \(recentMeal.carbs)g"
    }
}
