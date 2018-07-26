//
//  SuicaData.swift
//  TableView and Cell
//
//  Created by 宮内諒太 on 2018/07/12.
//  Copyright © 2018年 宮内諒太. All rights reserved.
//

import Foundation
import UIKit

//TableCell用のデータ型クラス
class SuicaData: NSObject, NSCoding {
    var day: String!
    var route: String!
    var price: String!
    var csvflg: Bool
    
    init(day: String, route: String, price: String, csvflg: Bool){
        self.day = day
        self.route = route
        self.price = price
        self.csvflg = csvflg
    }
    
    required init?(coder aDecoder: NSCoder) {
        day = aDecoder.decodeObject(forKey: "day") as? String
        route = aDecoder.decodeObject(forKey: "route") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        csvflg = aDecoder.decodeBool(forKey: "csvflg")
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(day, forKey: "day")
        aCoder.encode(route, forKey: "route")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(csvflg, forKey: "csvflg")
    }
}

