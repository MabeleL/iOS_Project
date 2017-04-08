//
//  FarmerTableViewCell.swift
//  Briq
//
//  Created by Apple on 07/04/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit

class FarmerTableViewCell: UITableViewCell {

    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var txtFarmerName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
