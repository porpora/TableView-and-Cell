//
//  HistoryViewController.swift
//  TableView and Cell
//
//  Created by 宮内諒太 on 2018/07/11.
//  Copyright © 2018年 宮内諒太. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var historyRefineLabel: UILabel!
    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var historyPickerText: UITextField!
    
    let userDefaults = UserDefaults.standard
    //使用する配列
    var suicaData = [SuicaData]()
    var pickerDayMatchSuicaData = [SuicaData]()
    var historySuicaData = [SuicaData]()
    
    //picker
    let years = (2010...2020).map { $0 }
    let months = (1...12).map { $0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションバー
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "アプリ名"
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.title = "編集"
        
        //pickerTextに対する日付プロパティ
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "y", options: 0, locale: Locale(identifier: "ja_JP"))
        let year = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM", options: 0, locale: Locale(identifier: "ja_JP"))
        var month = ""
        if dateFormatter.string(from: Date()).prefix(1) == "0" {
            month = String(dateFormatter.string(from: Date()).suffix(2))
        } else {
            month = dateFormatter.string(from: Date())
        }
        historyPickerText.text = year + " " + month
        
        //picker
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white
        pickerView.delegate = self
        historyPickerText.inputView = pickerView
        setKeyboardAccessory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //最新を常にロードする。
        if let storedSuicaList = userDefaults.object(forKey: "suicaData") as? Data {
            suicaData = (NSKeyedUnarchiver.unarchiveObject(with: storedSuicaList) as? [SuicaData])!
        }
        //matchするため変換
        guard var user_choice_day = historyPickerText.text else{
            return
        }
        if user_choice_day.count == 8{
            if let range = user_choice_day.range(of: "年") {
                user_choice_day.replaceSubrange(range, with: "0")
                print(user_choice_day)
            }
        }
        let day = user_choice_day.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined()
        //pickerの年月とmatchしたデータ配列
        pickerDayMatchSuicaData = suicaData.filter{ $0 .day.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined().prefix(6) == day }
        historySuicaData = pickerDayMatchSuicaData.filter{ $0 .csvflg == true }
        
        self.HistoryTableView.reloadData()
        super .viewWillAppear(true)
    }
    //pickerの表示数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else if component == 1 {
            return months.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(years[row])年"
        } else if component == 1 {
            return "\(months[row])月"
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = years[pickerView.selectedRow(inComponent: 0)]
        let month = months[pickerView.selectedRow(inComponent: 1)]
        historyPickerText.text = "\(year)年 \(month)月"
    }
    func setKeyboardAccessory() {
        let keyboardAccessory = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 36))
        keyboardAccessory.backgroundColor = UIColor.white
        historyPickerText.inputAccessoryView = keyboardAccessory
        
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: keyboardAccessory.bounds.size.width, height: 36))
        topBorder.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        keyboardAccessory.addSubview(topBorder)
        
        let completeButton = UIButton(frame: CGRect(x: keyboardAccessory.bounds.size.width - 48 , y: 0, width: 48, height: keyboardAccessory.bounds.size.height - 0.5 * 2))
        completeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        completeButton.setTitle("完了", for: .normal)
        completeButton.setTitleColor(UIColor.blue, for: .normal)
        completeButton.setTitleColor(UIColor.red, for: .highlighted)
        completeButton.addTarget(self, action: #selector(hidePickerView), for: .touchUpInside)
        keyboardAccessory.addSubview(completeButton)
        
        let bottomBorder = UIView(frame: CGRect(x: 0, y: keyboardAccessory.bounds.size.height - 0.5, width: keyboardAccessory.bounds.size.width, height: 0.5))
        bottomBorder.backgroundColor = UIColor.lightGray
        keyboardAccessory.addSubview(bottomBorder)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hidePickerView()
        self.viewWillAppear(true)
    }
    @objc func hidePickerView() {
        historyPickerText.resignFirstResponder()
    }
    
    //削除起動　↓↓↓↓↓
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        HistoryTableView.isEditing = editing
        
        //レイアウト編集
        if editing == true {
            navigationItem.rightBarButtonItem?.title = "完了"
        } else {
        navigationItem.rightBarButtonItem?.title = "編集"
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if let int = suicaData.index(of: historySuicaData[indexPath.row]) {
            suicaData[int].csvflg = false
        }
        //データ型にシリアライズして保存
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: suicaData), forKey: "suicaData")
        //同期
        userDefaults.synchronize()
        
        //最新情報を反映
        self.viewWillAppear(true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    // ↑↑↑↑↑↑↑↑↑↑
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyRefineLabel.text = "送信済み：\(suicaData.filter{ $0 .csvflg == true }.count)件"
        return historySuicaData.count
    }
    //テーブルにデータを表示する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HistorySelectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! HistorySelectTableViewCell
        
        cell.render(historySuicaData[indexPath.row])
        
        return cell
    }
}
