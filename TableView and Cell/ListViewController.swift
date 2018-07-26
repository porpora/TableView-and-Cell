//
//  ListViewController.swift
//  TableView and Cell
//
//  Created by 宮内諒太 on 2018/07/12.
//  Copyright © 2018年 宮内諒太. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate{
    
    @IBOutlet weak var TableView: UITableView!
    
    //使用する配列
    var someObjArray = [SomeObj]()
    
    let someObj = [
        SomeObj(days: "2018/07/02 09:00", place: "711", price: "1"),
        SomeObj(days: "2018/07/03 09:00", place: "家族市場", price: "2"),
        SomeObj(days: "2018/07/04 09:00", place: "元気になろう", price: "3"),
        SomeObj(days: "2018/07/05 09:00", place: "ちょっと立ち寄る", price: "4"),
        SomeObj(days: "2018/07/06 09:00", place: "All100yen?", price: "5"),
        SomeObj(days: "2018/07/09 09:00", place: "輪K", price: "6"),
        SomeObj(days: "2018/07/10 09:00", place: "日々ザキヤマ", price: "7"),
        SomeObj(days: "2018/07/11 09:00", place: "午前午後", price: "8"),
        SomeObj(days: "2018/07/12 09:00", place: "POP", price: "9")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaultsへの保存処理
        
        someObjArray.insert(someObj[0], at: 0)
        someObjArray.insert(someObj[1], at: 1)
        someObjArray.insert(someObj[2], at: 2)
        someObjArray.insert(someObj[3], at: 3)
        someObjArray.insert(someObj[4], at: 4)
        someObjArray.insert(someObj[5], at: 5)
        someObjArray.insert(someObj[6], at: 6)
        someObjArray.insert(someObj[7], at: 7)
        someObjArray.insert(someObj[8], at: 8)
        
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: someObjArray), forKey: "someObjs")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(someObjArray.count)
        return someObjArray.count
    }
    
    
    //テーブルの行毎のセルを返却する
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        //ラベルにデータを格納していく
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = someObj[indexPath.row].days!
        
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = someObj[indexPath.row].place!
        
        let label3 = cell.viewWithTag(3) as! UILabel
        label3.text = "¥" + someObj[indexPath.row].price!
        
        /*チェックボックス？
         let choiceCell = choiceCellList[indexPath.row]
         if choiceCell.choice {
         cell.accessoryType = UITableViewCellAccessoryType.checkmark
         }else{
         cell.accessoryType =
         UITableViewCellAccessoryType.none
         }*/
        return cell
    }
    
    func loadSomeObjs() -> [SomeObj]?{
        if let loadedData = UserDefaults().data(forKey: "someObjs"){
            let someObjs = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as! [SomeObj]
            return someObjs
        }else{
            return nil
        }
    }
}

//TableCell用のデータ型クラス
class SomeObj: NSObject, NSCoding {
    var days: String?
    var place: String?
    var price: String?
    
    init(days: String, place: String, price: String){
        self.days = days
        self.place = place
        self.price = price
    }
    
    required init?(coder aDecoder: NSCoder) {
        days = aDecoder.decodeObject(forKey: "days") as? String
        place = aDecoder.decodeObject(forKey: "place") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: "days")
        aCoder.encode(place, forKey: "place")
        aCoder.encode(price, forKey: "place")
    }
}

