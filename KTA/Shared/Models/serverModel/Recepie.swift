//
//  Recepie.swift
//  KTA
//
//  Created by qadeem on 23/02/2021.
//

import Foundation

// MARK: - Recepie
struct RecepieElement: Codable {
    init () {
        // do nothing
        name = ""
        recipieID = ""
        detailDescription = ""
        servings = 0
        preparationTime = 0
        imagePath = ""
        notes = ""
        recipieType = RecipieType(rawValue: "BreakFast")!
        nutrition = []
        ingredients = []
        recipiesInstructions = []
    }
    
    let nutrition: [Nutrition]
    let ingredients, recipiesInstructions: [String]
    let name, recipieID: String
    let recipieType: RecipieType
    let detailDescription: String
    let servings, preparationTime: Int
    let imagePath: String
    let notes: String

    enum CodingKeys: String, CodingKey {
        case nutrition, ingredients, recipiesInstructions, name
        case recipieID = "recipieId"
        case recipieType, detailDescription, servings
        case preparationTime = "preparation_time"
        case imagePath, notes
    }
    
}

// MARK: - Nutrition
struct Nutrition: Codable {
    let calories, netCarbs, fat, protein: Double

    enum CodingKeys: String, CodingKey {
        case calories
        case netCarbs = "net_carbs"
        case fat, protein
    }
}

enum RecipieType: String, Codable {
    case breakFast = "BreakFast"
    case breakfast = "breakfast"
    case dinner = "dinner"
    case lunch = "lunch"
}

typealias Recepie = [RecepieElement]
