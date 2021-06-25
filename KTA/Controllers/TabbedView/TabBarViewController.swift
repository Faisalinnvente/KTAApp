//
//  TabBarViewController.swift
//  KTA
//
//  Created by qadeem on 11/02/2021.
//

import UIKit
import CustomerlySDK

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var homeViewController: HomeViewController!
    var foodViewController: FoodViewController!
    var customMealsViewController: CustomMealsViewController!
    var chatViewController: ChatViewController!
    var moreViewController: MoreViewController!
    
    var previousIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        initControllers()
        setImages();
        
        let moreNavigationController = UINavigationController(rootViewController: moreViewController)
        let HomeNavigationController = UINavigationController(rootViewController: homeViewController)
        let FoodNavigationController = UINavigationController(rootViewController: foodViewController)
        let CustomMealsNavigationController = UINavigationController(rootViewController: customMealsViewController)
        
        viewControllers = [HomeNavigationController, FoodNavigationController, CustomMealsNavigationController, chatViewController, moreNavigationController]
       
    }
    
    func initControllers() {
        homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        foodViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoodViewController") as? FoodViewController
        customMealsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomMealsViewController") as? CustomMealsViewController
        chatViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        moreViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController
    }
    
    func setImages() {
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "iconHome")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "iconHome")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        homeViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal);
        homeViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected);
        
        foodViewController.tabBarItem = UITabBarItem(title: "Food", image: UIImage(named: "iconFood")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "iconFood")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        foodViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal);
        foodViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected);

        customMealsViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "iconAdd")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "iconAdd")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        customMealsViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal);
        customMealsViewController.tabBarItem.imageInsets = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0);

        
        chatViewController.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "iconChat")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "iconChat")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        chatViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal);
        chatViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected);
        
        moreViewController.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "iconMore")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "iconMore")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        moreViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal);
        moreViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected);
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Chat" {
            previousIndex = self.selectedIndex
            initChat()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (selectedIndex == 3) {
            self.selectedIndex = previousIndex
        }
    }
    
    func initChat() {
        Customerly.sharedInstance.configure(appId: "c501a5c0")
        Customerly.sharedInstance.activateApp()
        Customerly.sharedInstance.verboseLogging = true

        //Customerly.sharedInstance.registerUser(email: "faisal.javaid6@gmail.com", user_id: "5419910", name: "Faisal javaid")
        Customerly.sharedInstance.openSupport(from: self)
    }

}
