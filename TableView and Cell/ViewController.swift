//
//  ViewController.swift
//  TableView and Cell
//
//  Created by 宮内諒太 on 2018/07/06.
//  Copyright © 2018年 宮内諒太. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, CellDelegate,UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate{
    

    @IBOutlet weak var pickerText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var refineLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    //checkされているかのフラグ
    var checkflg = [Int]()
    //buttonimage
    let checkedImage = UIImage(named: "check_on")!
    let uncheckedImage = UIImage(named: "check_off")!
    
    //picker
    let years = (2010...2020).map { $0 }
    let months = (1...12).map { $0 }

    //使用する配列
    var suicaData = [SuicaData]()
    var pickerDayMatchSuicaData = [SuicaData]()
    var listSuicaData = [SuicaData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //buttonプロパティ
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        
        tabBarItem.title = "リスト"
        
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
        pickerText.text = year + " " + month
        
        //picker
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white
        pickerView.delegate = self
        pickerText.inputView = pickerView
        setKeyboardAccessory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Viewが表示される直前に動く
    override func viewWillAppear(_ animated: Bool) {
        //最新を常にロードする。
        if let storedSuicaList = userDefaults.object(forKey: "suicaData") as? Data {
            suicaData = (NSKeyedUnarchiver.unarchiveObject(with: storedSuicaList) as? [SuicaData])!
        }
        //matchするため変換
        guard var user_choice_day = pickerText.text else{
            return
        }
        if user_choice_day.count == 8{
            if let range = user_choice_day.range(of: "年") {
                user_choice_day.replaceSubrange(range, with: "0")
            }
        }
        let day = user_choice_day.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined()
        //pickerの年月とmatchしたデータ配列
        pickerDayMatchSuicaData = suicaData.filter{ $0 .day.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined().prefix(6) == day }
        //flgがfalseの物のみ抽出したデータ配列
        listSuicaData = pickerDayMatchSuicaData.filter{ $0 .csvflg == false }
        
        self.tableView.reloadData()
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
        pickerText.text = "\(year)年 \(month)月"
    }
    func setKeyboardAccessory() {
        let keyboardAccessory = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 36))
        keyboardAccessory.backgroundColor = UIColor.white
        pickerText.inputAccessoryView = keyboardAccessory

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
    }
    @objc func hidePickerView() {
        pickerText.resignFirstResponder()
        self.viewWillAppear(true)
    }
    
    //行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //csvflgがfalseの物をカウントする。
        return listSuicaData.count
    }
 
    //テーブルの行毎のセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SelectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! SelectTableViewCell
        
        cell.render(listSuicaData[indexPath.row])
        cell.delegate = self
        
        let selectbutton = cell.selectButton
        //チェックフラグに格納されている行番号とindexPathとの比較
        if checkflg.index(of: indexPath.row) != nil{
            selectbutton?.setImage(checkedImage, for: UIControlState())
        } else {
            selectbutton?.setImage(uncheckedImage, for: UIControlState())
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func buttonDidTap() {
        print("保留")
    }
    
    //checkbox ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hidePickerView()
        if checkflg.index(of: indexPath.row) != nil{
            checkflg.remove(at: checkflg.index(of: indexPath.row)!)
        } else {
            checkflg.append(indexPath.row)
        }
        print(checkflg)
        //重複チェック
        let orderedSet = NSOrderedSet(array: checkflg)
        checkflg = orderedSet.array as! [Int]
        
        //1つでも選択されていたらcsv化対応ボタンに変更
        if checkflg == [] {
            refineLabel.text =  "選択済み：0件"
            button.setTitle("SUICA の新着履歴を読み込む", for: .normal)
        } else {
            refineLabel.text =  "選択済み：\(checkflg.count)件"
            button.setTitle("確認画面へ", for: .normal)
        }
        tableView.reloadData()
    }
    
    //buttontap時にsuica情報を格納する。
    @IBAction func ButtonTap(_ sender: Any) {
        //スクレーピング処理の予定
        if checkflg == [] {
            suicaData = [
                SuicaData(day: "2018/07/02 08:23", route: "東京→新橋", price: "100円", csvflg: false),
                SuicaData(day: "2018/07/03 08:59", route: "新橋→五反田", price: "223円", csvflg: false),
                SuicaData(day: "2018/07/04 09:13", route: "渋谷→新宿", price: "332円", csvflg: false),
                SuicaData(day: "2018/07/05 10:50", route: "新宿→渋谷", price: "544円", csvflg: false),
                SuicaData(day: "2018/07/06 11:14", route: "大阪→京都", price: "5266円", csvflg: false),
                SuicaData(day: "2018/07/09 16:40", route: "田町→西日暮里", price: "736円", csvflg: false),
                SuicaData(day: "2018/07/10 18:20", route: "池袋→大塚", price: "742円", csvflg: false),
                SuicaData(day: "2018/07/11 20:00", route: "大塚→品川", price: "832円", csvflg: false),
                SuicaData(day: "2018/07/12 23:20", route: "上野→浜松町", price: "912円", csvflg: false),
                SuicaData(day: "2018/06/02 12:22", route: "恵比寿→代々木", price: "211円", csvflg: false),
                SuicaData(day: "2018/06/03 13:55", route: "巣鴨→目白", price: "222円", csvflg: false),
                SuicaData(day: "2018/06/04 08:39", route: "高田馬場→原宿", price: "263円", csvflg: false),
                SuicaData(day: "2018/06/05 09:21", route: "御徒町→神田", price: "446円", csvflg: false),
                SuicaData(day: "2018/05/06 04:59", route: "日暮里→駒込", price: "286円", csvflg: false),
                SuicaData(day: "2018/05/09 09:13", route: "有楽町→目黒", price: "426円", csvflg: false),
                SuicaData(day: "2018/05/10 13:41", route: "五反田→大崎", price: "177円", csvflg: false),
                SuicaData(day: "2018/05/11 15:39", route: "日暮里→上野", price: "368円", csvflg: false),
                SuicaData(day: "2018/05/12 22:11", route: "秋葉原→東京", price: "319円", csvflg: false)
            ]
            
            //データ型にシリアライズして保存
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: suicaData), forKey: "suicaData")
            //同期
            userDefaults.synchronize()
            //最新情報を反映
            self.viewWillAppear(true)
        } else {
            //csc化処理
//            let thePath = NSHomeDirectory()+"/Documents/\(String(describing: pickerText.text!)).csv"
            var csvData = [String]()
            //checkの付いている行のフラグをtrueにする。
            for index in 0..<checkflg.count {
                if let int = suicaData.index(of: listSuicaData[checkflg[index]]){
                    suicaData[int].csvflg = true
                }
            }

            for index in 0..<suicaData.count {
                if suicaData[index].csvflg == true {
                   csvData.append ("日付:\(suicaData[index].day!) 場所:\(suicaData[index].route!) 値段:\(suicaData[index].price!)円")
                }
            }
//            //csvのデータの行末に改行をし、Stringクラスに変換する。
//            let string = csvData.joined(separator: "\n").description
//
//            do {
//                try string.write(toFile: thePath, atomically: true, encoding: String.Encoding.utf8)
//                print("保存に成功。")
//            } catch {
//                print("保存に失敗。")
//            }
            //テスト
            if MFMailComposeViewController.canSendMail() == false {
                print("Email Send Failed")
                return
            }
            sendMailWithCSV(subject: "メール件名", message: "メール本文", csv: csvData)
            //データ型にシリアライズして保存
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: suicaData), forKey: "suicaData")
            //同期
            userDefaults.synchronize()
            //フラグの初期化
            checkflg.removeAll()
            //テキストの初期化
            button.setTitle("SUICA の新着履歴を読み込む", for: .normal)
            refineLabel.text =  "選択済み：0件"
            //最新情報を反映
            self.viewWillAppear(true)
        }
    }
    func sendMailWithCSV(subject: String, message: String, csv: [String]){
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        let toRecipients = ["pr_mn.r14_tea@i.softbank.jp"]
//        let CcRecipients = ["cc@1gmail.com"]
//        let BccRecipients = ["Bcc1@1gamil.com","Bcc2@1gmail.com"]
        
        mailViewController.setSubject(subject)
        mailViewController.setToRecipients(toRecipients)
//        mailViewController.setCcRecipients(CcRecipients)
//        mailViewController.setBccRecipients(BccRecipients)
        mailViewController.setMessageBody(message, isHTML: false)
        mailViewController.addAttachmentData(toCSV(csv: csv).data(using: String.Encoding.utf8, allowLossyConversion: false)! , mimeType: "text/csv", fileName: "\(String(describing: pickerText.text!)).csv")
        self.present(mailViewController, animated: true)
    }
    func toCSV(csv: [String]) -> String  {
        return csv.joined(separator: "\n").description
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            print("Email Send Cancelled")
            break
        case .saved:
            print("Email Saved as a Draft")
            break
        case .sent:
            print("Email Sent Successfully")
            break
        default:
            print("Email Send Failed")
            break
        }
        
        dismiss(animated: true, completion: nil)
    }

}
