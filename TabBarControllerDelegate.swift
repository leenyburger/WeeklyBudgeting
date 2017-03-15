//
//  TabBarControllerDelegate.swift
//  WeeklyBudgeting
//
//  Created by silveroak on 7/1/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import UIKit

class TabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    //Delegate set in storyboard 
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController)->Bool {
        let navController = viewController as!UINavigationController
        if (navController.viewControllers[0] .isKindOfClass(SettingsTableViewController)){
            let sTVC = navController.viewControllers[0] as! SettingsTableViewController
            sTVC.loadFromDataModel = true
        }
        return true
    }

}
