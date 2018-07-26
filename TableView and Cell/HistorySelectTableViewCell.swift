//
//  HistorySelectTableViewCell.swift
//  TableView and Cell
//
//  Created by 宮内諒太 on 2018/07/23.
//  Copyright © 2018年 宮内諒太. All rights reserved.
//

import UIKit

class HistorySelectTableViewCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func render(_ data:SuicaData){
        dataLabel.text = data.day
        routeLabel.text = data.route
        priceLabel.text = "¥ " + data.price
    }
    
}
