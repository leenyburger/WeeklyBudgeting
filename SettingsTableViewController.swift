//
//  SettingsTableViewController.swift
//  WeeklyBudgeting
//
//  Created by Schnettler Family on 3/5/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import UIKit
import Dispatch

class SettingsTableViewController: UITableViewController, UITextFieldDelegate, SettingsDetailViewControllerDelegate{
    var dataModel:DataModel!    //From appDelegate .plist
    var loadFromDataModel:Bool = true //Load from data model versus user input.  When returning from Detail VC, this should be false, otherwise (coming from antoher tab) true
    @IBOutlet weak var weekStart: UILabel!
    @IBOutlet weak var notifyMe: UILabel!
    @IBOutlet weak var currencyFormat: UILabel!
    @IBOutlet weak var weeklyBudget: UITextField!

    @IBAction func saveSettings(sender: AnyObject) {
        dataModel.settingsData.weeklyBudget = (weeklyBudget.text as NSString).doubleValue
        dataModel.settingsData.currency = currencyFormat.text!
        dataModel.settingsData.weekStart = convertDayToInt(weekStart.text!)
        dataModel.settingsData.remind = convertDayToInt(notifyMe.text!)
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        hudView.text = "Saved"
        let delayInSeconds = 0.6
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(when, dispatch_get_main_queue(), {
            //hudView.removeFromSuperview()   //Animate Off Screen???
            hudView.removeHudView(hudView, animated: true)
        })
    }
    
    override func viewDidLoad() {
       
        tableView.rowHeight = 44
        updateTableViewFromDataModel()
        println("View did load was called")
        }
   
    override func viewWillAppear(animated: Bool) {
        println("Load from data model is \(loadFromDataModel)")
        self.weeklyBudget.text = String(format:"%.2f",dataModel.settingsData.weeklyBudget)
        if (loadFromDataModel == true) {
           updateTableViewFromDataModel()
        }
    }
    
    func updateTableViewFromDataModel(){
        weekStart.text = populateWeekDays(dataModel.settingsData.weekStart)
        notifyMe.text = populateWeekDays(dataModel.settingsData.remind)
        currencyFormat.text = dataModel.settingsData.currency
    }
    
    
    func convertDayToInt(day:String)->Int {
        var intAsDay = -1
        switch day {
            case "Sunday": intAsDay = 1
            case "Monday": intAsDay = 2
            case "Tuesday":intAsDay = 3
            case "Wednesday": intAsDay = 4
            case"Thursday":intAsDay = 5
            case "Friday":intAsDay = 6
            case "Saturday":intAsDay = 7
        default :
            println("The day does not exist")
        }
        return intAsDay
    }
    
    func populateWeekDays(i:Int) ->String {
        var text = ""
            if (i==1) {
                text = "Sunday"
            } else if (i==2) {
                text = "Monday"
            } else if (i==3) {
                text = "Tuesday"
            } else if (i==4) {
                text = "Wednesday"
            } else if (i==5) {
                text = "Thursday"
            } else if (i==6) {
                text = "Friday"
            } else if (i==7) {
                text = "Saturday"
            }
        return text
        
    }

    
    
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        dataModel.settingsData.weeklyBudget = (weeklyBudget.text as NSString).doubleValue
//        println("Weekly Budget in textfielddidendediting is \(dataModel.settingsData.weeklyBudget)")
//    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        weeklyBudget.resignFirstResponder()
        return false
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil  //Rows are not selectable
    }
    
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let controller = navigationController.topViewController as! SettingsDetailViewController
        controller.delegate = self
        if segue.identifier == "WeekStartSegue" {
            controller.indexToEdit = 0
        } else if segue.identifier == "NotifyMeSegue" {
            controller.indexToEdit = 1
        } else if segue.identifier == "CurrencySegue" {
            controller.indexToEdit = 2
        }
    }
    
//    //////////Delegate Methods For Detail View Controller////////////
    func settingsDetailViewController(controller: SettingsDetailViewController, didFinishSettings indexSelected: Int, selectedItem:String) {
        
        //Update table view but don't save until the user hits "Save"
        if (indexSelected) == 0 {
            weekStart.text = selectedItem
            println("indexSelected was 0 \(selectedItem) should be populated")
        }
        else if (indexSelected == 1){
            notifyMe.text = selectedItem
        }
        else if (indexSelected == 2) {
            currencyFormat.text = selectedItem
        }
        self.loadFromDataModel = false
        self.navigationController?.popViewControllerAnimated(true)
    }
}