//
//  LunchViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 27/9/2567 BE.
//

import UIKit

class LunchViewController: UIViewController {

    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var carbohydrateLabel: UILabel!
    
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var sugarView: UIView!
    @IBOutlet weak var proteinView: UIView!
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var carbohydrateView: UIView!
    
    @IBOutlet weak var waterStepper: UIStepper!
    @IBOutlet weak var waterInputLabel: UILabel!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var proteinSegmentedControl: UISegmentedControl!
    @IBOutlet weak var carbsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var carbohydrateSegmentedControl: UISegmentedControl!

    // Nutrient values
    var waterIntake: Double = 0.0 // in liters
    var sugarIntake: Double = 0.0 // in grams
    var proteinIntake: Double = 0.0 // in grams
    var carbsIntake: Double = 0.0 // in grams
    var carbohydrateIntake: Double = 0.0 // in grams

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waterLabel.text = "Cups Of WATER"
        sugarLabel.text = "Sugar"
        proteinLabel.text = "Protein"
        carbsLabel.text = "Carbs"
        carbohydrateLabel.text = "Carbohydrate"
        
        setUpViewCorners()
        
        
        // Configure the stepper
            waterStepper.minimumValue = 0
            waterStepper.maximumValue = 8 // Maximum is 2L (8 * 0.25)
            waterStepper.stepValue = 1 // Stepper increments by 1 (for 0.25L each)
            
            // Initialize the label to reflect the default value of the stepper
            waterInputLabel.text = String(format: "%.2f L", waterIntake)
        
        updateNutrientIntakes()
        
    }
    
    private func setUpViewCorners() {
            // Adjust the corner radius to your preference
            let cornerRadius: CGFloat = 20.0
            
            waterView.layer.cornerRadius = cornerRadius
            sugarView.layer.cornerRadius = cornerRadius
            proteinView.layer.cornerRadius = cornerRadius
            carbsView.layer.cornerRadius = cornerRadius
            carbohydrateView.layer.cornerRadius = cornerRadius

            // If you want to clip subviews to the rounded corners
            waterView.clipsToBounds = true
            sugarView.clipsToBounds = true
            proteinView.clipsToBounds = true
            carbsView.clipsToBounds = true
            carbohydrateView.clipsToBounds = true
        }
    
        @IBAction func waterStepperChanged(_ sender: UIStepper) {
            waterIntake = sender.value * 0.25 // each step is 0.25L
            waterInputLabel.text = String(format: "%.2f L", waterIntake) // Update label to show current water intake
            updateNutrientIntakes()
        }
        
        // Segmented control actions
        @IBAction func sugarSegmentedControlChanged(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0: // None
                sugarIntake = 0.0
            case 1: // Fruit
                sugarIntake = 10.0
            case 2: // Soft Drink
                sugarIntake = 15.0
            default:
                sugarIntake = 0.0
            }
        }
        
        @IBAction func proteinSegmentedControlChanged(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0: // None
                proteinIntake = 0.0
            case 1: // Egg
                proteinIntake = 13.0
            case 2: // Meat
                proteinIntake = 26.0
            default:
                proteinIntake = 0.0
            }
            updateNutrientIntakes()
        }
        
        @IBAction func carbsSegmentedControlChanged(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0: //None
                carbsIntake = 0.0
            case 1: //Pasta
                carbsIntake = 25.0
            case 2: // Bread
                carbsIntake = 50.0
            default:
                carbsIntake = 0.0
            }
            updateNutrientIntakes()
        }
        
        @IBAction func carbohydrateSegmentedControlChanged(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0: //None
                carbohydrateIntake = 0.0
            case 1: //Oats
                carbohydrateIntake = 65.0
            case 2: //Rice
                carbohydrateIntake = 100.0
            default:
                carbohydrateIntake = 0.0
            }
            updateNutrientIntakes()
        }
        
        // Update nutrient intakes and refresh chart data
        private func updateNutrientIntakes() {
            // This function will update the chart in ChartViewController
            let totalWater = waterIntake // In liters
            let totalSugar = sugarIntake // In grams
            let totalProtein = proteinIntake // In grams
            let totalCarbs = carbsIntake // In grams
            let totalCarbohydrates = carbohydrateIntake // In grams

            // Send updated data to ChartViewController
            if let chartVC = self.navigationController?.viewControllers.filter({ $0 is ChartViewController }).first as? ChartViewController {
                chartVC.updateNutrientData(water: totalWater, sugar: totalSugar, protein: totalProtein, carbs: totalCarbs, carbohydrates: totalCarbohydrates)
            }
        }
    
}
