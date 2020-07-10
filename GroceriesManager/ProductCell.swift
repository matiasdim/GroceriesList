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
    @IBOutlet weak var notesTitleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.notesTitleLabel.text = "Notes"
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = Constants.mainColor
    }
    
    @objc private func longPress() {
        self.backgroundColor = Constants.thirdColor
    }

}
