//
//  TabBarViewController.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabItems = self.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItemSecond = tabItems[2]
            tabItemSecond.badgeValue = "New"
            
            let tabItemThree = tabItems[3]
            tabItemThree.badgeValue = "16"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
