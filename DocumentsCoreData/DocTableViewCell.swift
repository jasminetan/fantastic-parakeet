//
//  DocTableViewCell.swift
//  DocumentsCoreData
//
//  Created by Jasmine Tan on 2/21/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import UIKit

class DocTableViewCell: UITableViewCell {

    @IBOutlet weak var modLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
