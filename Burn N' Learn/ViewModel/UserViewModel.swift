//
//  PermissionHealthKitSetup.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 26/9/2567 BE.
//

import Foundation
import HealthKit

class UserViewModel {

    private let hkHealthStore: HKHealthStore
    
    // Closures to bind data to the View
    var age: ((Int) -> Void)?
    var biologicalSex: ((String) -> Void)?
    var bloodType: ((String) -> Void)?
    var stepCount: ((Double) -> Void)?
    var activeEnergyBurned: ((Double) -> Void)?
    var distanceWalkingRunning: ((Double) -> Void)?
    var heartRate: ((Double) -> Void)?
    var onSleepAnalysis: ((Double) -> Void)?
    var onError: ((String) -> Void)?

    // Dependency injection for testing or future flexibility
    init(hkHealthStore: HKHealthStore = HKHealthStore()) {
        self.hkHealthStore = hkHealthStore
    }

    // Fetch user age, biological sex, and blood type
    func fetchUserDetails() {
        do {
            let birthdayComponents = try hkHealthStore.dateOfBirthComponents()
            let biologicalSex = try hkHealthStore.biologicalSex().biologicalSex
            let bloodType = try hkHealthStore.bloodType().bloodType
            
            let today = Date()
            let calendar = Calendar.current
            if let birthDate = calendar.date(from: birthdayComponents) {
                let ageComponents = calendar.dateComponents([.year], from: birthDate, to: today)
                if let userAge = ageComponents.year {
                    age?(userAge)
                }
            }
            
            self.biologicalSex?(biologicalSex.stringRepresentation)
            self.bloodType?(bloodType.stringRepresentation)
        } catch {
            onError?("Failed to fetch user details: \(error.localizedDescription)")
        }
    }

    // Fetch step count
    func fetchStepCount() {
        fetchQuantity(for: .stepCount, unit: HKUnit.count()) { [weak self] quantity, error in
            if let count = quantity {
                self?.stepCount?(count)
            } else if let error = error {
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    // Fetch active energy burned
    func fetchActiveEnergyBurned() {
        fetchQuantity(for: .activeEnergyBurned, unit: HKUnit.kilocalorie()) { [weak self] quantity, error in
            if let energyBurned = quantity {
                self?.activeEnergyBurned?(energyBurned)
            } else if let error = error {
                self?.onError?(error.localizedDescription)
            }
        }
    }

    // Fetch distance walking/running
    func fetchDistanceWalkingRunning() {
        fetchQuantity(for: .distanceWalkingRunning, unit: HKUnit.meter()) { [weak self] quantity, error in
            if let distance = quantity {
                let distanceInKilometers = distance / 1000 // Convert meters to kilometers
                self?.distanceWalkingRunning?(distanceInKilometers)
            } else if let error = error {
                self?.onError?(error.localizedDescription)
            }
        }
    }

    // Fetch heart rate using HKSampleQuery
    func fetchHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            onError?("Heart Rate quantity type is unavailable.")
            return
        }

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            if let error = error {
                self?.onError?("Error fetching heart rate: \(error.localizedDescription)")
                return
            }

            if let samples = results as? [HKQuantitySample], let latestSample = samples.last {
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let heartRateValue = latestSample.quantity.doubleValue(for: heartRateUnit)
                
                DispatchQueue.main.async {
                    self?.heartRate?(heartRateValue)
                }
            } else {
                self?.onError?("No heart rate data available.")
            }
        }

        hkHealthStore.execute(query)
    }

    // Fetch sleep analysis using HKSampleQuery
    func fetchSleepAnalysis() {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            onError?("Sleep Analysis quantity type is unavailable.")
            return
        }

        // Look for sleep data over the past 24 hours
        let now = Date()
        let startOfDay = Calendar.current.date(byAdding: .day, value: -1, to: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            if let error = error {
                self?.onError?("Error fetching sleep data: \(error.localizedDescription)")
                return
            }

            if let sleepSamples = results as? [HKCategorySample] {
                // Filter out relevant sleep stages
                let asleepSamples = sleepSamples.filter {
                    $0.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue ||
                    $0.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue ||
                    $0.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue ||
                    $0.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue
                }

                let totalSleep = asleepSamples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
                let hours = totalSleep / 3600 // Convert seconds to hours

                DispatchQueue.main.async {
                    self?.onSleepAnalysis?(hours)
                }
            } else {
                self?.onError?("No sleep data available.")
            }
        }

        hkHealthStore.execute(query)
    }

    // Helper method to fetch HealthKit data
    private func fetchQuantity(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double?, Error?) -> Void) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid quantity type"]))
            return
        }

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil, error)
                return
            }
            
            completion(sum.doubleValue(for: unit), nil)
        }

        hkHealthStore.execute(query)
    }
}

// Extensions for readable string representations of biological sex and blood type
extension HKBiologicalSex {
    var stringRepresentation: String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .other:
            return "Other"
        default:
            return "Not Set"
        }
    }
}

extension HKBloodType {
    var stringRepresentation: String {
        switch self {
        case .aPositive:
            return "A+"
        case .aNegative:
            return "A-"
        case .bPositive:
            return "B+"
        case .bNegative:
            return "B-"
        case .abPositive:
            return "AB+"
        case .abNegative:
            return "AB-"
        case .oPositive:
            return "O+"
        case .oNegative:
            return "O-"
        default:
            return "Not Set"
        }
    }
}
