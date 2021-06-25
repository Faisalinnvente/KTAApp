//
//  DatabaseManager.swift
//  KTA
//
//  Created by qadeem on 14/02/2021.
//

import Foundation
import FMDB

var sharedInstance = DatabaseManager()

class DatabaseManager: NSObject {
    var database: FMDatabase? = nil
    
    class func getInstance() -> DatabaseManager {
        if sharedInstance.database == nil {
            sharedInstance.database = FMDatabase(path: Util.getDBPath("KTADB.db"))
        }
        
        return sharedInstance
    }
    
    //MARK: - Custom Meals Methods
    func addCustomMeal(_ customMealItem: CustomMeal) -> Bool{
        sharedInstance.database?.open()
        let isSave = sharedInstance.database?.executeUpdate("INSERT INTO customMeals (mealName, calories, fats, protien, carbs) VALUES (?,?,?,?,?)", withArgumentsIn: [customMealItem.mealName, customMealItem.calories, customMealItem.fats, customMealItem.protien, customMealItem.carbs])
        sharedInstance.database?.close()
        return isSave!
    }
    
    func updateCustomMeal(_ customMealItem: CustomMeal) -> Bool{
        sharedInstance.database?.open()
            
        let isUpdated = sharedInstance.database?.executeUpdate("UPDATE customMeals SET mealName=?, calories=?, fats=?, protien=?, carbs=? WHERE mealId=? ", withArgumentsIn: [customMealItem.mealName, customMealItem.calories, customMealItem.fats, customMealItem.protien, customMealItem.carbs, customMealItem.mealId])
            
        sharedInstance.database?.close()
        return isUpdated!
    }
    
    func getAllCustomMeals() -> [CustomMeal] {
        var data = [CustomMeal]()
        sharedInstance.database?.open()
        do {
            let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM customMeals", values: nil)
            
            if resultSet != nil{
                while resultSet!.next() {
                    let record = CustomMeal(mealId: Int((resultSet!.int(forColumn: "mealId"))) ,mealName: (resultSet!.string(forColumn: "mealName")!), calories: Int((resultSet!.int(forColumn: "calories"))), fats: Int((resultSet!.int(forColumn: "fats"))), protien: Int((resultSet!.int(forColumn: "protien"))), carbs: Int((resultSet!.int(forColumn: "carbs"))))
                    
                    data.append(record)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
        sharedInstance.database?.close()
        return data
    }
    
    
    //MARK: - Calories depleted tracking
    func trackCaloriesDepleted(_ modelInfo: CaloriesDepleted) -> Bool{
        sharedInstance.database?.open()
        let isSave = sharedInstance.database?.executeUpdate("INSERT INTO depletionTracking (calories, date) VALUES (?,?)", withArgumentsIn: [modelInfo.calories, modelInfo.date])
        sharedInstance.database?.close()
        return isSave!
    }
    
    func updateCaloriesDepleted(_ modelInfo: CaloriesDepleted) -> Bool{
        sharedInstance.database?.open()
            
        let isUpdated = sharedInstance.database?.executeUpdate("UPDATE depletionTracking SET calories=?, date=? WHERE date=? ", withArgumentsIn: [modelInfo.calories, modelInfo.date, modelInfo.date])
            
        sharedInstance.database?.close()
        return isUpdated!
    }
    
    func getDepletedCalories() -> [CaloriesDepleted] {
        var data = [CaloriesDepleted]()
        sharedInstance.database?.open()
        do {
            let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM depletionTracking", values: nil)
            
            if resultSet != nil{
                while resultSet!.next() {
                    let record = CaloriesDepleted(ID: Int((resultSet!.int(forColumn: "ID"))) ,calories: Int((resultSet!.int(forColumn: "calories"))), date: (resultSet!.string(forColumn: "date")!))
                    
                    data.append(record)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
        sharedInstance.database?.close()
        return data
    }
    
    //MARK: - Weight Tracking
    func trackWeight(_ modelInfo: WeightTracking) -> Bool{
        sharedInstance.database?.open()
        let isSave = sharedInstance.database?.executeUpdate("INSERT INTO weightTracking (weight, date) VALUES (?,?)", withArgumentsIn: [modelInfo.weight, modelInfo.date])
        sharedInstance.database?.close()
        return isSave!
    }
    
    func updateWeight(_ modelInfo: WeightTracking) -> Bool{
        sharedInstance.database?.open()
            
        let isUpdated = sharedInstance.database?.executeUpdate("UPDATE weightTracking SET weight=?, date=? WHERE date=? ", withArgumentsIn: [modelInfo.weight, modelInfo.date, modelInfo.date])
            
        sharedInstance.database?.close()
        return isUpdated!
    }
    
    func getWeightTracking() -> [WeightTracking] {
        var data = [WeightTracking]()
        sharedInstance.database?.open()
        do {
            let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM weightTracking", values: nil)
            
            if resultSet != nil{
                while resultSet!.next() {
                    let record = WeightTracking(ID: Int((resultSet!.int(forColumn: "ID"))) ,weight: Int((resultSet!.int(forColumn: "weight"))), date: (resultSet!.string(forColumn: "date")!))
                    
                    data.append(record)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
        sharedInstance.database?.close()
        return data
    }
    
    //MARK: - Water Tracking
    func trackWater(_ modelInfo: WaterTracking) -> Bool{
        sharedInstance.database?.open()
        let isSave = sharedInstance.database?.executeUpdate("INSERT INTO waterTracking (qunatity, date) VALUES (?,?)", withArgumentsIn: [modelInfo.quantity, modelInfo.date])
        sharedInstance.database?.close()
        return isSave!
    }
    
    func updateWater(_ modelInfo: WaterTracking) -> Bool{
        sharedInstance.database?.open()
            
        let isUpdated = sharedInstance.database?.executeUpdate("UPDATE waterTracking SET qunatity=?, date=? WHERE date=? ", withArgumentsIn: [modelInfo.quantity, modelInfo.date, modelInfo.date])
            
        sharedInstance.database?.close()
        return isUpdated!
    }
    
    func getWaterTracking() -> [WaterTracking] {
        var data = [WaterTracking]()
        sharedInstance.database?.open()
        do {
            let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM waterTracking", values: nil)
            
            if resultSet != nil{
                while resultSet!.next() {
                    let record = WaterTracking(ID: Int((resultSet!.int(forColumn: "ID"))) ,quantity: Int((resultSet!.int(forColumn: "qunatity"))), date: (resultSet!.string(forColumn: "date")!))
                    
                    data.append(record)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
        sharedInstance.database?.close()
        return data
    }
    
    //MARK: - Meal tracking
    func getMealTracking() -> [MealTracking] {
        var data = [MealTracking]()
        sharedInstance.database?.open()
        do {
            //let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM customMeals where date =?", values: data)
            let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM mealTracking", values: nil)
            
            if resultSet != nil{
                while resultSet!.next() {
                    let record = MealTracking(trackingId: Int((resultSet!.int(forColumn: "trackingId"))), mealId: (resultSet!.string(forColumn: "mealId")!) ,mealName: (resultSet!.string(forColumn: "mealName")!), calories: Int((resultSet!.int(forColumn: "calories"))), fats: Int((resultSet!.int(forColumn: "fats"))), protien: Int((resultSet!.int(forColumn: "protien"))), carbs: Int((resultSet!.int(forColumn: "carbs"))), servings: Int((resultSet!.int(forColumn: "servings"))), date: (resultSet!.string(forColumn: "date")!), week: Int((resultSet!.int(forColumn: "week"))), month: Int((resultSet!.int(forColumn: "month"))))
                    
                    data.append(record)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
        sharedInstance.database?.close()
        return data
    }
    
    func getIfAlreadyTracked(_ mealId: String , date: String) -> [MealTracking] {
        var data = [MealTracking]()
        sharedInstance.database?.open()
        do {
            //let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM customMeals where date =?", values: data)
            let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM mealTracking where mealId=? AND date=?", withArgumentsIn: [mealId, date])
            
            if resultSet != nil{
                while resultSet!.next() {
                    let record = MealTracking(trackingId: Int((resultSet!.int(forColumn: "trackingId"))), mealId: (resultSet!.string(forColumn: "mealId")!) ,mealName: (resultSet!.string(forColumn: "mealName")!), calories: Int((resultSet!.int(forColumn: "calories"))), fats: Int((resultSet!.int(forColumn: "fats"))), protien: Int((resultSet!.int(forColumn: "protien"))), carbs: Int((resultSet!.int(forColumn: "carbs"))), servings: Int((resultSet!.int(forColumn: "servings"))), date: (resultSet!.string(forColumn: "date")!), week: Int((resultSet!.int(forColumn: "week"))), month: Int((resultSet!.int(forColumn: "month"))))
                    
                    data.append(record)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
        
        sharedInstance.database?.close()
        return data
    }
    
    func trackMeal(_ trackingInfo: MealTracking) -> Bool{
        sharedInstance.database?.open()
        let isSave = sharedInstance.database?.executeUpdate("INSERT INTO mealTracking (mealId, mealName, calories, fats, protien, carbs, servings, date,week,month) VALUES (?,?,?,?,?,?,?,?,?,?)", withArgumentsIn: [trackingInfo.mealId, trackingInfo.mealName, trackingInfo.calories, trackingInfo.fats, trackingInfo.protien, trackingInfo.carbs, trackingInfo.servings, trackingInfo.date, trackingInfo.week, trackingInfo.month])
        sharedInstance.database?.close()
        return isSave!
    }
    
    func updateMealDetails(_ modelInfo: MealTracking) -> Bool{
        sharedInstance.database?.open()
            
        let isUpdated = sharedInstance.database?.executeUpdate("UPDATE mealTracking SET servings=? WHERE mealId=? ", withArgumentsIn: [modelInfo.servings, modelInfo.mealId])
            
        sharedInstance.database?.close()
        return isUpdated!
    }
    
    func deleteMeal(_ modelInfo: MealTracking) -> Bool{
        sharedInstance.database?.open()
        let isDeleted = (sharedInstance.database?.executeUpdate("DELETE FROM mealTracking WHERE mealId=?", withArgumentsIn: [modelInfo.mealId]))
        sharedInstance.database?.close()
        return isDeleted!
    }
    
    //MARK: - Bookmarks management
    func addBookmark(_ modelInfo: Bookmark) -> Bool{
        sharedInstance.database?.open()
        let isSave = sharedInstance.database?.executeUpdate("INSERT INTO bookmarks (recipieID) VALUES (?)", withArgumentsIn: [modelInfo.recipieID])
        sharedInstance.database?.close()
        return isSave!
    }
    
    func deleteBookMark(_ modelInfo: Bookmark) -> Bool{
        sharedInstance.database?.open()
        let isDeleted = (sharedInstance.database?.executeUpdate("DELETE FROM bookmarks WHERE recipieID=?", withArgumentsIn: [modelInfo.recipieID]))
        sharedInstance.database?.close()
        return isDeleted!
    }
    
    func isBookmarked(_ recepieID: String) -> Bool {
        var data = [Bookmark]()
        sharedInstance.database?.open()
        do {
            let resultSet : FMResultSet? = try sharedInstance.database?.executeQuery("SELECT * FROM bookmarks where recipieID=?", withArgumentsIn: [recepieID])
            
            if resultSet != nil{
                while resultSet!.next() {
                    let record = Bookmark(bookmarkID: Int((resultSet!.int(forColumn: "bookmarkID"))), recipieID: (resultSet!.string(forColumn: "recipieID")!))
                    data.append(record)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
        
        sharedInstance.database?.close()
        
        if data.count == 0 {
            return false
        } else {
            return true
        }
    }
}
