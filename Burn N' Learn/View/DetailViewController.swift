//
//  DetailViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 17/9/2567 BE.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // Store the nutrient data loaded from JSON
    var nutrientData: NutrientResponse? = nil
    var nutrientKeys: [String] = []  // Store keys like "Sugar", "Water", etc.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Fetch the nutrient data
        fetchNutrientData()
    }
    
    // MARK: - Load JSON Data with Alamofire
    func fetchNutrientData() {
        let url = "https://www.dropbox.com/scl/fi/m1hpkg5meu0t1lgd6r7qv/nutrientInfo.json?rlkey=dzn2t8n6d6ju5dep0awxinjtp&raw=1"
        print("got here")
        AF.request(url).responseDecodable(of: NutrientResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("Data is printed", data)
                self.nutrientData = data
                
                // Extract the keys for the table view
                self.nutrientKeys = ["Sugar", "Water", "Carbs", "Proteins", "Carbohydrates"]
                
                self.tableView.reloadData()
                print("Nutrient Data Loaded: \(data)")
                
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }

    }
    
    // MARK: - TableView Data Source and Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the count of nutrient keys
        return nutrientKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail_cell", for: indexPath) as! DetailViewCell
        
        // Get the key for the current row
        let nutrientKey = nutrientKeys[indexPath.row]
        
        // Access the nutrient info based on the key
        var nutrientInfo: NutrientInfo? = nil
        
        switch nutrientKey {
        case "Sugar":
            nutrientInfo = nutrientData?.sugar
        case "Water":
            nutrientInfo = nutrientData?.water
        case "Carbs":
            nutrientInfo = nutrientData?.carbs
        case "Proteins":
            nutrientInfo = nutrientData?.proteins
        case "Carbohydrates":
            nutrientInfo = nutrientData?.carbohydrates
        default:
            break
        }
        
        // Populate the cell with nutrient data
        cell.nutrientNameLabel?.text = nutrientKey
        cell.foodLabel?.text = "Foods: \(nutrientInfo?.foods.joined(separator: ", ") ?? "")"
        cell.recomendedIntakeLabel?.text = "Recommended Intake: \(nutrientInfo?.recommendedIntake ?? "")"
        cell.advantagesLabel?.text = "Advantages: \(nutrientInfo?.advantages ?? "")"
        
        // Set the image (ensure the image names match exactly)
        if let imageName = nutrientInfo?.image {
            cell.nutrientImageView.image = UIImage(named: imageName)
        }
        
        return cell
    }
}
