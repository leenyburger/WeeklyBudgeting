//
//  SettingsDetailViewController.swift
//  WeeklyBudgeting
//
//  Created by Schnettler Family on 3/23/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import UIKit
protocol SettingsDetailViewControllerDelegate:class {
    func settingsDetailViewController(controller:SettingsDetailViewController, didFinishSettings indexSelected:Int, selectedItem:String)
}

class SettingsDetailViewController: UITableViewController {

    var displayArray=["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var indexToEdit: Int?  //Send this from STVC in prepareforsegue.  Will always have a value
    weak var delegate : SettingsDetailViewControllerDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        determineDisplayArray()
    }
    
    func determineDisplayArray(){
        if (indexToEdit!==2) {
            self.displayArray = ["$","!"]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.displayArray.count
        }
    
    func setUpCellFormat(cell:UITableViewCell)->UITableViewCell {
        cell.backgroundColor = UIColorFromRGB(0x4A4A4A)
        cell.textLabel?.font = UIFont(name:"Cochin", size:15)
        cell.textLabel?.textColor = UIColorFromRGB(0xd7d7d7)
        return cell
    }
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsDetailCell")as! UITableViewCell
        setUpCellFormat(cell)
        cell.textLabel?.text = self.displayArray[indexPath.row]
        if (indexPath == indexToEdit!) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
            }
        cell.selectionStyle = .None
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Currently only works for day of week
        let selectedItem = displayArray[indexPath.row] //This returns a string value
        delegate?.settingsDetailViewController(self, didFinishSettings: indexToEdit!, selectedItem: selectedItem)
    }
   
    
       func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}