//
//  MainViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 26/9/2567 BE.
//

import UIKit

class MainViewController: UIViewController {
    
    // IBOutlets for UI components
    @IBOutlet weak var stepsData: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var distanceData: UILabel!
    @IBOutlet weak var burnData: UILabel!
    @IBOutlet weak var heartRateData: UILabel!
    @IBOutlet weak var sleepAnalysisData: UILabel!
    @IBOutlet weak var ageData: UILabel!
    @IBOutlet weak var sexData: UILabel!
    
    // IBOutlets for UI views (containing the labels)
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var bloodView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var burnView: UIView!
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var sexView: UIView!
    
    let userViewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()  // Setup UI elements' appearance
        
        // Request HealthKit permissions
        PermissionHealthKitSetup.authorizedHealthKitSetup { (success, error) in
            if success {
                // Bind ViewModel data to UI elements
                self.bindViewModel()
                
                // Fetch HealthKit data
                self.loadHealthKitData()
            } else {
                print("HealthKit Authorization Failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // Binding data from the ViewModel to the UI labels
    private func bindViewModel() {
        // Binding for steps
        userViewModel.stepCount = { [unowned self] steps in
            DispatchQueue.main.async {
                self.stepsData.text = "\(Int(steps)) steps"
            }
        }
        
        // Binding for active energy burned
        userViewModel.activeEnergyBurned = { [unowned self] calories in
            DispatchQueue.main.async {
                self.burnData.text = "\(Int(calories)) kcal"
            }
        }
        
        // Binding for distance
        userViewModel.distanceWalkingRunning = { [unowned self] distance in
            let distanceInKilometers = distance
            DispatchQueue.main.async {
                self.distanceData.text = String(format: "%.2f km", distanceInKilometers)
            }
        }
        
        // Binding for heart rate
        userViewModel.heartRate = { [unowned self] heartRate in
            DispatchQueue.main.async {
                self.heartRateData.text = "\(Int(heartRate)) bpm"
            }
        }
        
        // Binding for sleep analysis
        userViewModel.onSleepAnalysis = { [unowned self] sleepHours in
            DispatchQueue.main.async {
                self.sleepAnalysisData.text = String(format: "%.2f hours", sleepHours)
            }
        }
        
        // Binding for age
        userViewModel.age = { [unowned self] age in
            DispatchQueue.main.async {
                self.ageData.text = "\(age) years old"
            }
        }
        
        // Binding for biological sex
        userViewModel.biologicalSex = { [unowned self] sex in
            DispatchQueue.main.async {
                self.sexData.text = sex
            }
        }
        
        // Binding for blood type
        userViewModel.bloodType = { [unowned self] blood in
            DispatchQueue.main.async {
                self.bloodType.text = blood
            }
        }
        
        // Error handling
        userViewModel.onError = { error in
            print("Error: \(error)")
        }
    }
    
    // Function to load HealthKit data
    private func loadHealthKitData() {
        userViewModel.fetchUserDetails()
        userViewModel.fetchStepCount()
        userViewModel.fetchActiveEnergyBurned()
        userViewModel.fetchDistanceWalkingRunning()
        userViewModel.fetchHeartRate()  // Ensure heart rate data is fetched
        userViewModel.fetchSleepAnalysis()  // Ensure sleep analysis data is fetched
    }

    // Set up the UI views' appearance (rounded corners, shadows, etc.)
    private func setUpView() {
        let cornerRadius: CGFloat = 10.0
        
        // Apply corner radius to all views
        [stepView, bloodView, distanceView, burnView, heartView, sleepView, ageView, sexView].forEach { view in
            view?.layer.cornerRadius = cornerRadius
            view?.clipsToBounds = true
        }
        
        // Optionally, add shadow or other custom appearance
        [stepView, bloodView, distanceView, burnView, heartView, sleepView, ageView, sexView].forEach { view in
            view?.layer.shadowColor = UIColor.black.cgColor
            view?.layer.shadowOpacity = 0.2
            view?.layer.shadowOffset = CGSize(width: 0, height: 2)
            view?.layer.shadowRadius = 4
            view?.layer.masksToBounds = false
        }
    }
}
