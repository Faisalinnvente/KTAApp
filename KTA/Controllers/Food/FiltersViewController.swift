//
//  FiltersViewController.swift
//  KTA
//
//  Created by qadeem on 28/03/2021.
//

import UIKit

class FiltersViewController: UIViewController {
    var recepies: [RecepieElement] = []
    var filteredRecepies: [RecepieElement] = []
    var selectedTab = ""

    @IBOutlet weak var txtFilterName: UITextField!
    @IBOutlet weak var txtFilterIngredient: UITextField!
    
    @IBOutlet weak var pTime1: UIButton!
    @IBOutlet weak var pTime2: UIButton!
    @IBOutlet weak var pTime3: UIButton!
    @IBOutlet weak var pTime4: UIButton!
    @IBOutlet weak var pTime5: UIButton!
    @IBOutlet weak var pTime6: UIButton!
    
    @IBOutlet weak var protien1: UIButton!
    @IBOutlet weak var protien2: UIButton!
    @IBOutlet weak var protien3: UIButton!
    @IBOutlet weak var protien4: UIButton!
    @IBOutlet weak var protien5: UIButton!
    @IBOutlet weak var protien6: UIButton!
    
    @IBOutlet weak var fat1: UIButton!
    @IBOutlet weak var fat2: UIButton!
    @IBOutlet weak var fat3: UIButton!
    @IBOutlet weak var fat4: UIButton!
    @IBOutlet weak var fat5: UIButton!
    @IBOutlet weak var fat6: UIButton!
    
    @IBOutlet weak var carb1: UIButton!
    @IBOutlet weak var carb2: UIButton!
    @IBOutlet weak var carb3: UIButton!
    @IBOutlet weak var carb4: UIButton!
    @IBOutlet weak var carb5: UIButton!
    @IBOutlet weak var carb6: UIButton!
    
    @IBOutlet weak var cals1: UIButton!
    @IBOutlet weak var cals2: UIButton!
    @IBOutlet weak var cals3: UIButton!
    @IBOutlet weak var cals4: UIButton!
    @IBOutlet weak var cals5: UIButton!
    @IBOutlet weak var cals6: UIButton!
    
    @IBOutlet weak var btnFilter: UIButton!
    
    var pt1Filter = false
    var pt2Filter = false
    var pt3Filter = false
    var pt4Filter = false
    var pt5Filter = false
    var pt6Filter = false
    
    var p1Filter = false
    var p2Filter = false
    var p3Filter = false
    var p4Filter = false
    var p5Filter = false
    var p6Filter = false
    
    var fat1Filter = false
    var fat2Filter = false
    var fat3Filter = false
    var fat4Filter = false
    var fat5Filter = false
    var fat6Filter = false
    
    var carbs1Filter = false
    var carbs2Filter = false
    var carbs3Filter = false
    var carbs4Filter = false
    var carbs5Filter = false
    var carbs6Filter = false
    
    var cals1Filter = false
    var cals2Filter = false
    var cals3Filter = false
    var cals4Filter = false
    var cals5Filter = false
    var cals6Filter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func initViews() {
        btnFilter.layer.cornerRadius = 20.0
        
        styleButtons()
        addDoneButtonOnKeyboard()
    }
    
    func styleButtons() {
        addRoundedBorders(button: pTime1)
        addRoundedBorders(button: pTime2)
        addRoundedBorders(button: pTime3)
        addRoundedBorders(button: pTime4)
        addRoundedBorders(button: pTime5)
        addRoundedBorders(button: pTime6)
        
        addRoundedBorders(button: protien1)
        addRoundedBorders(button: protien2)
        addRoundedBorders(button: protien3)
        addRoundedBorders(button: protien4)
        addRoundedBorders(button: protien5)
        addRoundedBorders(button: protien6)
        
        addRoundedBorders(button: fat1)
        addRoundedBorders(button: fat2)
        addRoundedBorders(button: fat3)
        addRoundedBorders(button: fat4)
        addRoundedBorders(button: fat5)
        addRoundedBorders(button: fat6)
        
        addRoundedBorders(button: carb1)
        addRoundedBorders(button: carb2)
        addRoundedBorders(button: carb3)
        addRoundedBorders(button: carb4)
        addRoundedBorders(button: carb5)
        addRoundedBorders(button: carb6)
        
        addRoundedBorders(button: cals1)
        addRoundedBorders(button: cals2)
        addRoundedBorders(button: cals3)
        addRoundedBorders(button: cals4)
        addRoundedBorders(button: cals5)
        addRoundedBorders(button: cals6)
    }
    
    func addRoundedBorders(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtFilterName.inputAccessoryView = doneToolbar
        txtFilterIngredient.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        txtFilterName.resignFirstResponder()
        txtFilterIngredient.resignFirstResponder()
    }
    
    func setData(selectedTab: String, recepies: [RecepieElement]) {
        self.selectedTab = selectedTab
        self.recepies = recepies
    }

    @IBAction func pTimeFilter(_ sender: UIButton) {
        if sender.tag == 1 {
            pt1Filter = !pt1Filter
            if pt1Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
            
        } else if sender.tag == 2 {
            pt2Filter = !pt2Filter
            if pt2Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
            
        } else if sender.tag == 3 {
            pt3Filter = !pt3Filter
            if pt3Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 4 {
            pt4Filter = !pt4Filter
            if pt4Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 5 {
            pt5Filter = !pt5Filter
            if pt5Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 6 {
            pt6Filter = !pt6Filter
            if pt6Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        }
    }
    
    @IBAction func protienFilter(_ sender: UIButton) {
        if sender.tag == 1 {
            p1Filter = !p1Filter
            if p1Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 2 {
            p2Filter = !p2Filter
            if p2Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 3 {
            p3Filter = !p3Filter
            if p3Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 4 {
            p4Filter = !p4Filter
            if p4Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 5 {
            p5Filter = !p5Filter
            if p5Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 6 {
            p6Filter = !p6Filter
            if p6Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        }
    }
    
    @IBAction func fatFilter(_ sender: UIButton) {
        if sender.tag == 1 {
            fat1Filter = !fat1Filter
            if fat1Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
            
        } else if sender.tag == 2 {
            fat2Filter = !fat2Filter
            if fat2Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 3 {
            fat3Filter = !fat3Filter
            if fat3Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 4 {
            fat4Filter = !fat4Filter
            if fat4Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 5 {
            fat5Filter = !fat5Filter
            if fat5Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 6 {
            fat6Filter = !fat6Filter
            if fat6Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        }
    }
    
    @IBAction func carbsFilter(_ sender: UIButton) {
        if sender.tag == 1 {
            carbs1Filter = !carbs1Filter
            if carbs1Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 2 {
            carbs2Filter = !carbs2Filter
            if carbs2Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 3 {
            carbs3Filter = !carbs3Filter
            if carbs3Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 4 {
            carbs4Filter = !carbs4Filter
            if carbs4Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 5 {
            carbs5Filter = !carbs5Filter
            if carbs5Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 6 {
            carbs6Filter = !carbs6Filter
            if carbs6Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        }
    }
    
    @IBAction func caloriesFilter(_ sender: UIButton) {
        if sender.tag == 1 {
            cals1Filter = !cals1Filter
            if cals1Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 2 {
            cals2Filter = !cals2Filter
            if cals2Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 3 {
            cals3Filter = !cals3Filter
            if cals3Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 4 {
            cals4Filter = !cals4Filter
            if cals4Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 5 {
            cals5Filter = !cals5Filter
            if cals5Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        } else if sender.tag == 6 {
            cals6Filter = !cals6Filter
            if cals6Filter {
                sender.backgroundColor = .lightGray
                
            } else {
                sender.backgroundColor = .white
            }
        }
    }
    
    @IBAction func filterRecepies(_ sender: UIButton) {
        filteredRecepies = []

        if txtFilterName.text != "" {
            filteredRecepies = applyNameFilter(recepies: recepies)
        } else {
            filteredRecepies = recepies
        }
            
        if txtFilterIngredient.text != "" {
          filteredRecepies = applyIngredientFilter(recepies: filteredRecepies)
        }
        
        if pt1Filter || pt2Filter || pt3Filter || pt4Filter || pt4Filter || pt6Filter {
          filteredRecepies = applyTimeFilter(recepies: filteredRecepies)
        }
        
        if p1Filter || p2Filter || p3Filter || p4Filter || p5Filter || p6Filter {
          filteredRecepies = applyProtienFiter(recepies: filteredRecepies)
        }
        
        if fat1Filter || fat2Filter || fat3Filter || fat4Filter || fat5Filter || fat6Filter {
          filteredRecepies = applyFatFilter(recepies: filteredRecepies)
        }
        
        if carbs1Filter || carbs2Filter || carbs3Filter || carbs4Filter || carbs5Filter || carbs6Filter {
          filteredRecepies = applyCarbsFilter(recepies: filteredRecepies)
        }
        
        if cals1Filter || cals2Filter || cals3Filter || cals4Filter || cals5Filter || cals6Filter {
          filteredRecepies = applyCaloriesFilter(recepies: filteredRecepies)
        }
        
        print(filteredRecepies)
        
        let nc = NotificationCenter.default
        let mealInfoDict:[String: [RecepieElement]] = ["filteredRecepies": filteredRecepies]
        nc.post(name: Notification.Name("applyRecepieFilters"), object: nil, userInfo: mealInfoDict)
        self.navigationController?.popViewController(animated: true);
    }
    
    func applyNameFilter(recepies: [RecepieElement]) -> [RecepieElement] {
        var filtered: [RecepieElement] = []
        
        for recepie in recepies {
            if txtFilterName.text != "" {
                if  recepie.name.lowercased().contains((txtFilterName.text?.lowercased())!){
                    filtered.append(recepie)
                }
            }
        }
        
        return filtered
    }
    
    func applyIngredientFilter(recepies: [RecepieElement]) -> [RecepieElement] {
        var filtered: [RecepieElement] = []
        
        for recepie in recepies {
            if txtFilterIngredient.text != "" {
                var includeRecepie = false
                for ingredient in recepie.ingredients {
                    if  ingredient.lowercased().contains((txtFilterIngredient.text?.lowercased())!){
                        includeRecepie = true
                    }
                }
                
                if includeRecepie {
                    filtered.append(recepie)
                }
                
            }
        }
        
        return filtered
    }
    
    func applyTimeFilter(recepies: [RecepieElement]) -> [RecepieElement] {
        var filtered: [RecepieElement] = []
        
        for recepie in recepies {
            var includeRecepie = false
            
            if pt1Filter {
                if  recepie.preparationTime >= 1 && recepie.preparationTime <= 5 {
                    includeRecepie = true
                }
            }
            
            if pt2Filter {
                if  recepie.preparationTime >= 6 && recepie.preparationTime <= 10 {
                    includeRecepie = true
                }
            }
            
            if pt3Filter {
                if  recepie.preparationTime >= 11 && recepie.preparationTime <= 20 {
                    includeRecepie = true
                }
            }
            
            if pt4Filter {
                if  recepie.preparationTime >= 21 && recepie.preparationTime <= 30 {
                    includeRecepie = true
                }
            }
            
            if pt5Filter {
                if  recepie.preparationTime >= 31 && recepie.preparationTime <= 50 {
                    includeRecepie = true
                }
            }
            
            if pt6Filter {
                if  recepie.preparationTime > 50 {
                    includeRecepie = true
                }
            }
            
            if includeRecepie {
                filtered.append(recepie)
            }
        }
        
        return filtered
    }
    
    func applyProtienFiter(recepies: [RecepieElement]) -> [RecepieElement] {
        var filtered: [RecepieElement] = []
        
        for recepie in recepies {
            var includeRecepie = false
            
            if p1Filter {
                if  recepie.nutrition[0].protein >= 1 && recepie.nutrition[0].protein <= 10 {
                    includeRecepie = true
                }
            }
            
            if p2Filter {
                if  recepie.nutrition[0].protein >= 11 && recepie.nutrition[0].protein <= 20 {
                    includeRecepie = true
                }
            }
            
            if p3Filter {
                if  recepie.nutrition[0].protein >= 21 && recepie.nutrition[0].protein <= 40 {
                    includeRecepie = true
                }
            }
            
            if p4Filter {
                if  recepie.nutrition[0].protein >= 41 && recepie.nutrition[0].protein <= 60 {
                    includeRecepie = true
                }
            }
            
            if p5Filter {
                if  recepie.nutrition[0].protein >= 61 && recepie.nutrition[0].protein <= 100 {
                    includeRecepie = true
                }
            }
            
            if p6Filter {
                if  recepie.nutrition[0].protein >= 100 {
                    includeRecepie = true
                }
            }
            
            if includeRecepie {
                filtered.append(recepie)
            }
        }
        
        return filtered
    }
    
    func applyFatFilter(recepies: [RecepieElement]) -> [RecepieElement] {
        var filtered: [RecepieElement] = []
        
        for recepie in recepies {
            var includeRecepie = false
            
            if fat1Filter {
                if  recepie.nutrition[0].fat >= 1 && recepie.nutrition[0].fat <= 10 {
                    includeRecepie = true
                }
            }
            
            if fat2Filter {
                if  recepie.nutrition[0].fat >= 11 && recepie.nutrition[0].fat <= 20 {
                    includeRecepie = true
                }
            }
            
            if fat3Filter {
                if  recepie.nutrition[0].fat >= 21 && recepie.nutrition[0].fat <= 40 {
                    includeRecepie = true
                }
            }
            
            if fat4Filter {
                if  recepie.nutrition[0].fat >= 41 && recepie.nutrition[0].fat <= 60 {
                    includeRecepie = true
                }
            }
            
            if fat5Filter {
                if  recepie.nutrition[0].fat >= 61 && recepie.nutrition[0].fat <= 100 {
                    includeRecepie = true
                }
            }
            
            if fat6Filter {
                if  recepie.nutrition[0].fat >= 100 {
                    includeRecepie = true
                }
            }
            
            if includeRecepie {
                filtered.append(recepie)
            }
        }
        
        return filtered
    }
    
    func applyCarbsFilter(recepies: [RecepieElement]) -> [RecepieElement] {
        var filtered: [RecepieElement] = []
        
        for recepie in recepies {
            var includeRecepie = false
            
            if carbs1Filter {
                if  recepie.nutrition[0].netCarbs >= 1 && recepie.nutrition[0].netCarbs <= 10 {
                    includeRecepie = true
                }
            }
            
            if carbs2Filter {
                if  recepie.nutrition[0].netCarbs >= 11 && recepie.nutrition[0].netCarbs <= 20 {
                    includeRecepie = true
                }
            }
            
            if carbs3Filter {
                if  recepie.nutrition[0].netCarbs >= 21 && recepie.nutrition[0].netCarbs <= 40 {
                    includeRecepie = true
                }
            }
            
            if carbs4Filter {
                if  recepie.nutrition[0].netCarbs >= 41 && recepie.nutrition[0].netCarbs <= 60 {
                    includeRecepie = true
                }
            }
            
            if carbs5Filter {
                if  recepie.nutrition[0].netCarbs >= 61 && recepie.nutrition[0].netCarbs <= 100 {
                    includeRecepie = true
                }
            }
            
            if carbs6Filter {
                if  recepie.nutrition[0].netCarbs >= 100 {
                    includeRecepie = true
                }
            }
            
            if includeRecepie {
                filtered.append(recepie)
            }
        }
        
        return filtered
    }
    
    func applyCaloriesFilter(recepies: [RecepieElement]) -> [RecepieElement] {
        var filtered: [RecepieElement] = []
        
        for recepie in recepies {
            var includeRecepie = false
            
            if cals1Filter {
                if  recepie.nutrition[0].calories >= 1 && recepie.nutrition[0].calories <= 20 {
                    includeRecepie = true
                }
            }
            
            if cals2Filter {
                if  recepie.nutrition[0].calories >= 21 && recepie.nutrition[0].calories <= 50 {
                    includeRecepie = true
                }
            }
            
            if cals3Filter {
                if  recepie.nutrition[0].calories >= 51 && recepie.nutrition[0].calories <= 80 {
                    includeRecepie = true
                }
            }
            
            if cals4Filter {
                if  recepie.nutrition[0].calories >= 81 && recepie.nutrition[0].calories <= 120 {
                    includeRecepie = true
                }
            }
            
            if cals5Filter {
                if  recepie.nutrition[0].calories >= 121 && recepie.nutrition[0].calories <= 200 {
                    includeRecepie = true
                }
            }
            
            if cals6Filter {
                if  recepie.nutrition[0].calories >= 200 {
                    includeRecepie = true
                }
            }
            
            if includeRecepie {
                filtered.append(recepie)
            }
        }
        
        return filtered
    }
    
}
