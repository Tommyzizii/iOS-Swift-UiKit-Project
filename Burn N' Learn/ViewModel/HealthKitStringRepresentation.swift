//
//  HealthKitStringRepresentation.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 26/9/2567 BE.
//

import Foundation
import HealthKit

class HealthKitStringRepresentation {
    
    // Convert HKBloodType to a human-readable string
    static func stringRepresentation(for bloodType: HKBloodType) -> String {
        switch bloodType {
        case .aPositive: return "A+"
        case .aNegative: return "A-"
        case .bPositive: return "B+"
        case .bNegative: return "B-"
        case .abPositive: return "AB+"
        case .abNegative: return "AB-"
        case .oPositive: return "O+"
        case .oNegative: return "O-"
        case .notSet: return "Not Set"
        @unknown default: return "Unknown"
        }
    }
    
    // Convert HKBiologicalSex to a human-readable string
    static func stringRepresentation(for biologicalSex: HKBiologicalSex) -> String {
        switch biologicalSex {
        case .male: return "Male"
        case .female: return "Female"
        case .other: return "Other"
        case .notSet: return "Not Set"
        @unknown default: return "Unknown"
        }
    }
    
    // Convert sleep analysis data to a human-readable string
    static func stringRepresentation(for sleepSamples: [HKCategorySample]) -> String {
        var sleepString = ""
        
        for sample in sleepSamples {
            let startDate = sample.startDate
            let endDate = sample.endDate
            let sleepState = sample.value == HKCategoryValue.notApplicable.rawValue ? "In Bed" : "Asleep"
            sleepString += "From \(startDate) to \(endDate): \(sleepState)\n"
        }
        
        return sleepString.isEmpty ? "No sleep data available." : sleepString
    }
}
