//
//  OperationTableViewCell.swift
//  Purse
//
//  Created by Kuroyan Juliett on 30.06.2018.
//  Copyright © 2018 C3G9. All rights reserved.
//

import Foundation
import UIKit

class OperationTableViewCell: UITableViewCell {
    public static let reuseId = "OperationTableViewCell_reuseId"
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    public func configure(for info: String, and sum: Int) {
        infoLabel.text = info
        sumLabel.text = "\(sum)"
    }
}
