//
//  ProductCell.swift
//  GroceriesManager
//
//  Created by Matías Gil Echavarría on 7/7/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var observationTitleLabel: UILabel!
    @IBOutlet weak var observationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.observationTitleLabel.text = "Observation"
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = Constants.mainColor
        self.tintColor = .red
    }
    
    @objc private func longPress() {
        self.backgroundColor = Constants.thirdColor
    }

}
