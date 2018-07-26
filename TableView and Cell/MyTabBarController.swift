//
//  MyTabBarController.swift
//  TableView and Cell
//
//  Created by 宮内諒太 on 2018/07/11.
//  Copyright © 2018年 宮内諒太. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            print("")
//            if let test = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
//                test.loadViewIfNeeded()
//                test.viewDidLoad()
//        }
        case 1:
            self.loadView()
            self.viewDidLoad()
            print("")
        default:
            print("失敗")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
