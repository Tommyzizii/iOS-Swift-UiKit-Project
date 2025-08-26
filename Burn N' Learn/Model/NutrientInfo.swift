//
//  NutrientInfo.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 18/9/2567 BE.
//

import Foundation

// MARK: - Nutrient Info Model
struct NutrientResponse: Codable {
    let sugar: NutrientInfo
    let water: NutrientInfo
    let carbs: NutrientInfo
    let proteins: NutrientInfo
    let carbohydrates: NutrientInfo

    enum CodingKeys: String, CodingKey {
        case sugar = "Sugar"
        case water = "Water"
        case carbs = "Carbs"
        case proteins = "Proteins"
        case carbohydrates = "Carbohydrates"
    }
}


struct NutrientInfo: Codable {
    let foods: [String]
    let recommendedIntake: String
    let advantages: String
    let image: String
}
