//
//  PermissionHealthKitSetup.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 26/9/2567 BE.
//

import Foundation
import HealthKit

class PermissionHealthKitSetup {
    
    private enum PermissionHealthKitError: Error {
        case deviceNotAvailable
        case dataNotAvailable
    }
    
    class func authorizedHealthKitSetup(completion: @escaping (Bool, Error?) -> Void) {
        
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, PermissionHealthKitError.deviceNotAvailable)
            return
        
        }
        
        // Define the HealthKit data types we want to read
        guard let dataOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
              let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let stepsCount = HKObjectType.quantityType(forIdentifier: .stepCount),
              let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
              let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(false, PermissionHealthKitError.dataNotAvailable)
            return
        }
        
        // Combine the data types into a set for reading
        let hkHealthKitToReadDataTypes: Set<HKObjectType> = [
            dataOfBirth,
            bloodType,
            biologicalSex,
            stepsCount,
            activeEnergyBurned,
            distanceWalkingRunning,
            heartRate,
            sleepAnalysis,
        ]
        
        // Request authorization to read the specified data types
        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: nil, read: hkHealthKitToReadDataTypes) { success, error in
            completion(success, error)
        }
    }
}
