//
//  RecepieDetailsViewController.swift
//  KTA
//
//  Created by qadeem on 02/03/2021.
//

import UIKit
import Firebase

class RecepieDetailsViewController: UIViewController {
    let baseUrl = "http://104.248.108.131:3000/api/recepies/"
    var recepieType = "breakfast"

    @IBOutlet weak var lblRecepieName: UILabel!
    @IBOutlet weak var imgRecepie: UIImageView!
    @IBOutlet weak var txtRecepieDescription: UILabel!
    @IBOutlet weak var lblNutrition: UILabel!
    @IBOutlet weak var lblIngredients: UILabel!
    @IBOutlet weak var lblPreparation: UILabel!
    @IBOutlet weak var lblPrepTime: UILabel!
    
    @IBOutlet weak var btnTrackMeal: UIButton!
    
    var recepie: RecepieElement = RecepieElement()
    var recepieID: String = ""
    
    var isBookmarked = false
    var bookmarkItem = Bookmark(bookmarkID: 0, recipieID: "")
    
    @IBOutlet weak var viewBookmark: UIView!
    @IBOutlet weak var viewtime: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("view_recepie_details", parameters: nil)
        initViews()
    }
    
    func initViews() {
        btnTrackMeal.layer.cornerRadius = 20.0
        viewtime.layer.cornerRadius = 15
        viewBookmark.layer.cornerRadius = viewBookmark.frame.height/2
        
        if recepieID == "" {
            setDetails()
        } else {
            getRecepieDetails(from: baseUrl, type: recepieType)
        }
    }
    
    func addTapGestures() {
        let bookmarkGesture = UITapGestureRecognizer(target: self, action: #selector(addToBookmark(_:)))
        bookmarkGesture.numberOfTapsRequired = 1
        bookmarkGesture.numberOfTouchesRequired = 1
        
        viewBookmark.addGestureRecognizer(bookmarkGesture);
        viewBookmark.isUserInteractionEnabled = true
    }
    
    func isRecepieBookmarked() {
        isBookmarked =  DatabaseManager.getInstance().isBookmarked(recepie.recipieID)
        configureBookmarkView()
    }
    
    // Keto Details Button Events
    @objc func addToBookmark(_ gesture: UITapGestureRecognizer) {
        isBookmarked = !isBookmarked
        self.bookmarkItem = Bookmark(bookmarkID: 0, recipieID: self.recepie.recipieID)
        
        if isBookmarked {
            var isSave = DatabaseManager.getInstance().addBookmark(self.bookmarkItem)
            
            if recepie.recipieType.rawValue == "breakfast" || recepie.recipieType.rawValue == "BreakFast" {
                Analytics.logEvent("add_breakfast_to_bookmark", parameters: ["meal_name": recepie.name])
            } else if recepie.recipieType.rawValue == "lunch" {
                Analytics.logEvent("add_lunch_to_bookmark", parameters: ["meal_name": recepie.name])
            } else if recepie.recipieType.rawValue == "dinner" {
                Analytics.logEvent("add_dinner_to_bookmark", parameters: ["meal_name": recepie.name])
            }
        } else {
            var isDelete = DatabaseManager.getInstance().deleteBookMark(self.bookmarkItem)
            
            if recepie.recipieType.rawValue == "breakfast" || recepie.recipieType.rawValue == "BreakFast" {
                Analytics.logEvent("remove_breakfast_bookmark", parameters: ["meal_name": recepie.name])
            } else if recepie.recipieType.rawValue == "lunch" {
                Analytics.logEvent("remove_lunch_bookmark", parameters: ["meal_name": recepie.name])
            } else if recepie.recipieType.rawValue == "dinner" {
                Analytics.logEvent("remove_dinner_bookmark", parameters: ["meal_name": recepie.name])
            }
        }
        
        configureBookmarkView()
    }
    
    func configureBookmarkView() {
        if isBookmarked {
            viewBookmark.backgroundColor = UIColor.lightGray
        } else {
            viewBookmark.backgroundColor = UIColor.white
        }
    }
    
    func setData(recepieDetails: RecepieElement) {
        self.recepie = recepieDetails
    }
    
    func setData(recepieID: String, recepieType: String) {
        self.recepieID = recepieID
        self.recepieType = recepieType
    }
    
    private func getRecepieDetails(from url: String, type: String) {
        print("\(url)\(type)/\(recepieID)")
        let req = URLSession.shared
        
        URLSession.shared.dataTask(with: URL(string: "\(url)\(type)/\(recepieID)")!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something occured")
                return
            }
            
            var result: RecepieElement?
            do {
                result = try JSONDecoder().decode(RecepieElement.self, from: data)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let recepie = result else {
                return
            }
            
            print(recepie)
            DispatchQueue.main.async {
                self.recepie = recepie
                self.setDetails()
            }
            
        }).resume()
    }
    
    func setDetails() {
        isRecepieBookmarked()
        addTapGestures()
        
        lblRecepieName.text = recepie.name
        txtRecepieDescription.text = recepie.detailDescription
        lblPrepTime.text = "\(recepie.preparationTime)m"
        
        lblNutrition.text = "Calories • \(recepie.nutrition[0].calories) kcal Fats • \(recepie.nutrition[0].fat)g Proteins • \(recepie.nutrition[0].protein)g Carbs • \(recepie.nutrition[0].netCarbs)g"
        
        var ingredientsString = "";
        var j = 1
        for ingredient in recepie.ingredients {
            ingredientsString = ingredientsString + String(j) + ". " + ingredient + "\n"
            j = j + 1
        }
        lblIngredients.text = ingredientsString;
        
        var instructionsString = "";
        var i = 1
        for instruction in recepie.recipiesInstructions {
            instructionsString = instructionsString + String(i) + ". " + instruction + "\n"
            i = i + 1
        }
        
        lblPreparation.text = instructionsString
        imgRecepie.sd_setImage(with: URL(string: "http://104.248.108.131:3000/assets/\(recepie.recipieType)/\(recepie.recipieID).jpg")!, placeholderImage: UIImage(named: "recepieplaceholder"))
        //imgRecepie?.imageFrom(url: URL(string: "http://127.0.0.1:5001/assets/\(recepie.recipieType)/\(recepie.recipieID).jpg")!)
    }
    
    @IBAction func trackMeal(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "trackMealViewController") as! trackMealViewController
        vc.setRecepie(recepieDetails: self.recepie)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
    }
}
