//
//  AddSpendingViewController.swift
//  WeeklyBudgeting
//
//  Created by Schnettler Family on 2/26/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import UIKit
import CoreData

class AddSpendingViewController: UIViewController, UITextFieldDelegate {
    var managedObjectContext:NSManagedObjectContext!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBAction func changeDate(sender: UITextField) {
        var datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode=UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    var itemToEdit:SpendingData?    //locationToEdit it tutorial.  In adding mode it will be nil 
    var indexToEdit:NSIndexPath?
    var newDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.enabled = false    //disable delete button
        deleteButton.hidden = true      //hide delete button
        setUpView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        location.becomeFirstResponder()
    }
    
    func setUpView() {
        if let item = itemToEdit {  //If editing an existing item.  The user selected an item in the TableView
            deleteButton.enabled = true
            deleteButton.hidden = false
            location.text = item.category
            let amountSpent = item.amountSpent
            amount.text = String(format:"%.2f",item.amountSpent)
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            date.text = formatter.stringFromDate(item.dateSpent!)
        }
        else {
            var today = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            date.text = formatter.stringFromDate(today)
        }
    }
    
    func handleDatePicker(sender:UIDatePicker){
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        date.text = formatter.stringFromDate(sender.date)
        newDate = sender.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //////////////////////////////////////////////////
    //Button Actions
    //////////////////////////////////////////////////
    
    @IBAction func deleteSpending(sender: AnyObject) {
        if let item = itemToEdit{   //Simply delete the item that was sent to the VC.  Send back the item
            managedObjectContext.deleteObject(item)
            var error:NSError?
            if !managedObjectContext.save(&error) {
                fatalCoreDataError(error)
            }

        }
         dismissViewControllerAnimated(true , completion: nil)
    }
    @IBAction func cancel() {
         dismissViewControllerAnimated(true , completion: nil)
    }
    
       @IBAction func done() {
        var item : SpendingData     //item is of type spending data 
        if let temp = itemToEdit    //if itemToEdit exists the user is editing an item
        {
            item = temp
        } else
        {
            item = NSEntityDescription.insertNewObjectForEntityForName("SpendingData", inManagedObjectContext: managedObjectContext) as! SpendingData
        }
 
        item.category = location.text
        item.amountSpent = (amount.text as NSString).doubleValue
        item.dateSpent = newDate
        var error:NSError?
        if !managedObjectContext.save(&error){
            fatalCoreDataError(error)
            return
        }
        
        if (location.text == nil) { //popup Do you want to add a location? Same for Amount and Date??
            }
        dismissViewControllerAnimated(true, completion: nil)
        
        
//        if let item = itemToEdit{   //If itemtoedit exists, the user is editing an existing item.
//            item.category = location.text
//            item.amountSpent = (amount.text as NSString).doubleValue
//            item.dateSpent = newDate
//            delegate?.addSpendingViewController(self, didFinishEditingItem: item, atIndexPath: indexToEdit!)
//        } else {
//            let item = SpendingData()
//            item.category  = location.text
//            item.amountSpent =  (amount.text as NSString).doubleValue
//            item.dateSpent=newDate
//            println("Contents of stuff:\(item.category), \(item.amountSpent), \(item.dateSpent)")
//            delegate?.addSpendingViewController(self, didFinishAddingItem: item)
//        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
