//
//  FoodViewController.swift
//  KTA
//
//  Created by qadeem on 11/02/2021.
//

import UIKit
import Firebase

class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var recepiesTableViewController: UITableView!
    //let baseUrl = "http://127.0.0.1:3000/api/recepies/"
    let baseUrl = "http://104.248.108.131:3000/api/recepies/"
    let assetsURL = "http://localhost:5001/assets/"
    var recepies: [RecepieElement] = []
    var selectedTab = "breakfast"
    var filtersApplied = false
    
    @IBOutlet weak var btnBreakfast: GradientButton!
    @IBOutlet weak var btnLunch: GradientButton!
    @IBOutlet weak var buttonDinner: GradientButton!
    @IBOutlet weak var btnCustom: GradientButton!
    @IBOutlet weak var btnBookmark: GradientButton!
    
    @IBOutlet weak var btnFilters: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //event
        Analytics.logEvent("select_food_screen", parameters: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !filtersApplied {
            let img = UIImage(named: "iconFiltersBlack") as UIImage?
            btnFilters.setBackgroundImage(img, for: .normal)
            btnFilters.bounds.size.height = 18
            btnFilters.bounds.size.width = 20
            
            initViews()
        } else {
            let img = UIImage(named: "iconFilter") as UIImage?
            btnFilters.setBackgroundImage(img, for: .normal)
            btnFilters.bounds.size.height = 40
            btnFilters.bounds.size.width = 40
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func initViews() {
        setSelectedTab()
        addObservers()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        if selectedTab == "bookmarks" {
            getBookmarkedRecepies(from: baseUrl, type: "breakfast")
        } else {
            getRecepies(from: baseUrl, type: selectedTab);
        }
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        recepiesTableViewController.register(nib, forCellReuseIdentifier: "TableViewCell")
        recepiesTableViewController.delegate = self
        recepiesTableViewController.dataSource = self
    }
    
    func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.applyFilters(_:)), name: Notification.Name("applyRecepieFilters"), object: nil)
    }
    
    @objc func applyFilters(_ notification: NSNotification) {
        self.recepies = []
        if let filteredRecepies = notification.userInfo?["filteredRecepies"] as? [RecepieElement] {
            self.recepies = filteredRecepies
            self.recepiesTableViewController.reloadData()
            self.filtersApplied = true
        }
    }
    
    @IBAction func openFilters(_ sender: Any) {
        self.filtersApplied = false
        let vc = storyboard?.instantiateViewController(identifier: "FiltersViewController") as! FiltersViewController
        vc.setData(selectedTab: self.selectedTab, recepies: self.recepies)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setSelectedTab() {
        self.filtersApplied = false
        let img = UIImage(named: "iconFiltersBlack") as UIImage?
        btnFilters.setBackgroundImage(img, for: .normal)
        btnFilters.bounds.size.height = 18
        btnFilters.bounds.size.width = 20
        
        deselectAllButons()
        
        if selectedTab == "breakfast" {
            selectBreakfastBtn()
        } else if selectedTab == "lunch" {
            selectLunchBtn()
        } else if selectedTab == "dinner" {
            selectDinnerBtn()
        } else if selectedTab == "custom" {
            selectCustomBtn()
        } else if selectedTab == "bookmarks" {
            selectBookmarkBtn()
        }
    }
    
    func deselectAllButons() {
        DeselectButton(button: btnBreakfast)
        DeselectButton(button: btnLunch)
        DeselectButton(button: btnCustom)
        DeselectButton(button: buttonDinner)
        DeselectButton(button: btnBookmark)
    }
    
    func DeselectButton(button: GradientButton) {
        button.leftGradientColor = .lightGray
        button.rightGradientColor = .lightGray
        
        button.alpha = 0.3
    }
    
    func selectBreakfastBtn() {
        btnBreakfast.leftGradientColor = UIColor(named: "Primary2")
        btnBreakfast.rightGradientColor = UIColor(named: "Primary")
        
        btnBreakfast.alpha = 1.0
        Analytics.logEvent("select_breakfast_tab", parameters: nil)
    }
    
    func selectLunchBtn() {
        btnLunch.leftGradientColor = UIColor(red: 0/255, green: 161/255, blue: 211/255, alpha: 1.0)
        btnLunch.rightGradientColor = UIColor(red: 85/255, green: 214/255, blue: 255/255, alpha: 0.77)
        
        btnLunch.alpha = 1.0
        Analytics.logEvent("select_lunch_tab", parameters: nil)
    }
    
    func selectDinnerBtn() {
        buttonDinner.leftGradientColor = UIColor(named: "Secondary2")
        buttonDinner.rightGradientColor = UIColor(named: "Secondary")
        
        buttonDinner.alpha = 1.0
        Analytics.logEvent("select_dinner_tab", parameters: nil)
    }
    
    func selectCustomBtn() {
        btnCustom.leftGradientColor = .systemOrange
        btnCustom.rightGradientColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        btnCustom.alpha = 1.0
        Analytics.logEvent("select_custom_tab", parameters: nil)
    }
    
    func selectBookmarkBtn() {
        btnBookmark.leftGradientColor = .link
        btnBookmark.rightGradientColor = .systemTeal
        
        btnBookmark.alpha = 1.0
        Analytics.logEvent("select_saved_tab", parameters: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recepies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recepiesTableViewController.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

        cell.configureCell(Recepie: recepies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "RecepieDetailsViewController") as! RecepieDetailsViewController
        vc.setData(recepieDetails: recepies[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func getRecepies(from url: String, type: String) {
        
        if let data = UserDefaults.standard.value(forKey:type) as? Data {
            let cachedRecepies = try? PropertyListDecoder().decode(Array<RecepieElement>.self, from: data)
            print(cachedRecepies)
            
            DispatchQueue.main.async {
                self.recepies = cachedRecepies ?? [RecepieElement]()
                self.recepiesTableViewController.reloadData()
                self.recepiesTableViewController.setContentOffset(.zero, animated: true)
            }
            
            return
        }

        print("\(url)\(type)")
        let req = URLSession.shared

        URLSession.shared.dataTask(with: URL(string: "\(url)\(type)")!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something occured")
                return
            }
            
            var result: Recepie?
            do {
                result = try JSONDecoder().decode(Recepie.self, from: data)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let recepies = result else {
                return
            }
            
            DispatchQueue.main.async {
                self.recepies = recepies
                self.recepiesTableViewController.reloadData()
                self.recepiesTableViewController.setContentOffset(.zero, animated: true)
            }
            
        }).resume()
    }
    
    var bookmarkedRecepies: [RecepieElement] = []
    func getBookmarkedRecepies(from url: String, type: String) {
        URLSession.shared.dataTask(with: URL(string: "\(url)\(type)")!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something occured")
                return
            }
            
            var result: Recepie?
            do {
                result = try JSONDecoder().decode(Recepie.self, from: data)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let recepies = result else {
                return
            }
            
            for recepie in recepies {
                let isBookmarked = DatabaseManager.getInstance().isBookmarked(recepie.recipieID)
                if isBookmarked {
                    self.bookmarkedRecepies.append(recepie)
                }
            }
            
            if type == "breakfast" {
                self.getBookmarkedRecepies(from: self.baseUrl, type: "lunch")
            } else if type == "lunch" {
                self.getBookmarkedRecepies(from: self.baseUrl, type: "dinner")
            } else {
                DispatchQueue.main.async {
                    self.recepies = self.bookmarkedRecepies
                    self.recepiesTableViewController.reloadData()
                    self.recepiesTableViewController.setContentOffset(.zero, animated: true)
                }
            }
        }).resume()
    }
    
    @IBAction func breakFastClicked(_ sender: Any) {
        selectedTab = "breakfast"
        getRecepies(from: baseUrl, type: "breakfast");
        
        setSelectedTab()
    }
    
    @IBAction func lunchClicked(_ sender: Any) {
        selectedTab = "lunch"
        getRecepies(from: baseUrl, type: "lunch");
        
        setSelectedTab()
    }
    
    @IBAction func dinnerClicker(_ sender: Any) {
        selectedTab = "dinner"
        getRecepies(from: baseUrl, type: "dinner");
        
        setSelectedTab()
    }
    
    @IBAction func customClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CustomMealsViewController") as! CustomMealsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        setSelectedTab()
    }
    
    @IBAction func bookmarksClicked(_ sender: Any) {
        selectedTab = "bookmarks"
        
        bookmarkedRecepies = []
        getBookmarkedRecepies(from: baseUrl, type: "breakfast")
        
        setSelectedTab()
    }
}
