//
//  ChartViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 17/9/2567 BE.
//

import UIKit
import Charts
import DGCharts

class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var topicLabel: UINavigationItem!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var nutrientData: [String: NutrientInfo] = [:] // This will hold the nutrient data
    
    // Additional properties to track intake
    var totalWater: Double = 0.0
    var totalSugar: Double = 0.0
    var totalProtein: Double = 0.0
    var totalCarbs: Double = 0.0
    var totalCarbohydrates: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicLabel.title = "Your Today's Nutrition"
        
        setUpPieChart()
        setPieChartData()
        
        // Set the chart's delegate to self for interaction
        pieChartView.delegate = self
    }
    
    func setUpPieChart() {
        pieChartView.chartDescription.enabled = false
        pieChartView.drawHoleEnabled = true
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = true
        pieChartView.isUserInteractionEnabled = true
        pieChartView.holeColor = UIColor.gray
        pieChartView.transparentCircleColor = UIColor.clear
        pieChartView.entryLabelColor = UIColor.black
        
        // Configure legend
        pieChartView.legend.enabled = true
        pieChartView.legend.font = UIFont.systemFont(ofSize: 14)
        pieChartView.legend.textColor = UIColor.black
        pieChartView.legend.verticalAlignment = .bottom
        pieChartView.legend.horizontalAlignment = .center
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.drawInside = false
        
        // Set chart offsets and hole size
        pieChartView.extraTopOffset = 20
        pieChartView.extraBottomOffset = 20
        pieChartView.extraLeftOffset = 20
        pieChartView.extraRightOffset = 20
        pieChartView.holeRadiusPercent = 0.3
        pieChartView.transparentCircleRadiusPercent = 0.4
    }
    
    func setPieChartData() {
        // Set default data for the chart
        let dataEntries = [
            PieChartDataEntry(value: totalSugar, label: "Sugar"),
            PieChartDataEntry(value: totalWater, label: "Water"),
            PieChartDataEntry(value: totalCarbs, label: "Carbs"),
            PieChartDataEntry(value: totalProtein, label: "Proteins"),
            PieChartDataEntry(value: totalCarbohydrates, label: "Carbohydrates")
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "Daily Consumption Rate")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.sliceSpace = 4.0
        dataSet.selectionShift = 5.0
        dataSet.valueFont = UIFont.systemFont(ofSize: 14)
        dataSet.valueTextColor = UIColor.black
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 1)
        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .insideSlice
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.notifyDataSetChanged()
    }
    
    // Method to update nutrient data
    func updateNutrientData(water: Double, sugar: Double, protein: Double, carbs: Double, carbohydrates: Double) {
        totalWater += water
        totalSugar += sugar
        totalProtein += protein
        totalCarbs += carbs
        totalCarbohydrates += carbohydrates
        
        setPieChartData() // Update the chart data after updating the nutrient values
    }
    
    // MARK: - Navigation
    
    @IBAction func nutrientDetails(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            // Pass the nutrient data to DetailViewController if needed
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("DetailViewController not found")
        }
    }
    
    @IBAction func didChangeSegmented(_ sender: UISegmentedControl) {
        navigateToInputViewController(forSegment: sender.selectedSegmentIndex)
    }
    
    func navigateToInputViewController(forSegment index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var newVC: UIViewController
        
        switch index {
        case 0:
            return  // No navigation; remain in this view controller
        case 1:
            if let breakfastVC = storyboard.instantiateViewController(withIdentifier: "BreakfastViewController") as? BreakfastViewController {
                newVC = breakfastVC
            } else {
                print("BreakfastViewController not found")
                return
            }
        case 2:
            if let lunchVC = storyboard.instantiateViewController(withIdentifier: "LunchViewController") as? LunchViewController {
                newVC = lunchVC
            } else {
                print("LunchViewController not found")
                return
            }
        case 3:
            if let dinnerVC = storyboard.instantiateViewController(withIdentifier: "DinnerViewController") as? DinnerViewController {
                newVC = dinnerVC
            } else {
                print("DinnerViewController not found")
                return
            }
        default:
            print("Invalid segment index")
            return
        }
        
        // Push the new view controller to the navigation stack
        navigationController?.pushViewController(newVC, animated: true)
    }
}
