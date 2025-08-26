//
//  UserModel.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 26/9/2567 BE.
//

import Foundation
import HealthKit

class UserModel {
    
    var age: Int?
    var bloodType: HKBloodType?
    var biologicalSex: HKBiologicalSex?
    var stepsCount: Double?
    var activeEnergyBurned: Double?
    var distanceWalkingRunning: Double?
    var heartRate: Double?
    var sleepAnalysis: [HKCategorySample]? // Store sleep analysis samples
    
    // Initializer
    init(age: Int? = nil, bloodType: HKBloodType? = nil, biologicalSex: HKBiologicalSex? = nil,
         stepsCount: Double? = nil, activeEnergyBurned: Double? = nil,
         distanceWalkingRunning: Double? = nil, heartRate: Double? = nil, sleepAnalysis: [HKCategorySample]? = nil) {
        self.age = age
        self.bloodType = bloodType
        self.biologicalSex = biologicalSex
        self.stepsCount = stepsCount
        self.activeEnergyBurned = activeEnergyBurned
        self.distanceWalkingRunning = distanceWalkingRunning
        self.heartRate = heartRate
        self.sleepAnalysis = sleepAnalysis
    }
}
