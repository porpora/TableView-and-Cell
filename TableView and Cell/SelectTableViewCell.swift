//
//  SelectTableViewCell.swift
//  TableView and Cell
//
//  Created by 宮内諒太 on 2018/07/19.
//  Copyright © 2018年 宮内諒太. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func buttonDidTap()
}
class SelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var delegate: CellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(_ data:SuicaData){
        //ラベルにデータを格納していく
        dateLabel.text = data.day
        routeLabel.text = data.route
        priceLabel.text = "¥ " + data.price
    }

    @IBAction func selectButtonTap(_ sender: UIButton) {
        print(sender)
        delegate.buttonDidTap()
    }
//    @IBAction func SelectButtonTap(_ sender: Any) {
//        delegate.buttonDidTap()
//    }
}
