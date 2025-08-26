//
//  DetailViewCell.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 18/9/2567 BE.
//

import UIKit

class DetailViewCell: UITableViewCell {
    
    @IBOutlet weak var nutrientImageView: UIImageView!
    @IBOutlet weak var nutrientNameLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var recomendedIntakeLabel: UILabel!
    @IBOutlet weak var advantagesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
