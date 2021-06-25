//
//  InfoStartViewController.swift
//  KTA
//
//  Created by qadeem on 05/02/2021.
//

import UIKit

class InfoStartViewController: UIViewController {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var btnGoal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var t: [TestModel] = DatabaseManager.getInstance().getData()
        //print(t)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initControls()
    }
    
    private func initControls() {
        // Shadow and Radius for Circle Button
        btnGoal.layer.shadowColor = UIColor.black.cgColor
        btnGoal.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        btnGoal.layer.masksToBounds = false
        btnGoal.layer.shadowRadius = 5.0
        btnGoal.layer.shadowOpacity = 0.1
        btnGoal.layer.cornerRadius = 25
    }
    
    @IBAction func btnGoalClicked(_ sender: Any) {
        //let testModel =  TestModel(ID: 0, Name: "new Name 15", LastName: "last new name 5")
        //let isSave = DatabaseManager.getInstance().saveDate(testModel)
        //let isUpdate = DatabaseManager.getInstance().updateStudent(testModel)
        //let isDelete = DatabaseManager.getInstance().deleteStudent(testModel)
        //print(isDelete);
        
        let vc = storyboard?.instantiateViewController(identifier: "GoalViewController") as! GoalViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}


