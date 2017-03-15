//
//  HomeViewController.swift
//  WeeklyBudgeting
//
//  Created by silveroak on 2/11/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//  Main View Controller

import UIKit
import CoreData

class HomeViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var budgetLabelText: UILabel!

    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var budgetLabelGraph: UILabel!
    @IBAction func addSpending(sender: AnyObject) {
    }
    @IBOutlet weak var amountLeft: UITextField!
    @IBAction func handleTap(sender: AnyObject) {   //Open setting page
        self.tabBarController?.selectedIndex = 2
    }
    
    var managedObjectContext:NSManagedObjectContext!
    var weekStart:NSDate?
    var weekEnd:NSDate?
    lazy var fetchedResultsController:NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("SpendingData", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key:"dateSpent", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize=20
        
        let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "SpendingData")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    var dataModel:DataModel! //SettingsData comes from .plist values
    private var cw = CalculateWeek()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
        self.setUpView()
        populateLabels()
    }
    
    func performFetch(){
        var error:NSError?
        if !fetchedResultsController.performFetch(&error){
            fatalCoreDataError(error)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        weekStart = cw.weekStart(dataModel.settingsData.weekStart)
        weekEnd = cw.weekEnd(weekStart!)
        //tableView.reloadData()
        populateLabels()
        }
    
    deinit{
        fetchedResultsController.delegate = nil
    }
    
    func setUpView(){
        self.view.backgroundColor = UIColorFromRGB(0x2B2B2B)
        self.amountLeft.font = UIFont(name:"Cochin", size :35)
        self.amountLeft.textColor = UIColorFromRGB(0x007AFF)
    }
    
    func populateLabels() {
        let displayAmount = String(format:"%.2f",amountLeftToSpend())
        let displayBudget = String (format:"%.2",dataModel.settingsData.weeklyBudget)
        self.amountLeft.text =  displayAmount
        self.budgetLabelGraph.text = displayBudget
        self.budgetLabelText.text = ("Your weekly budget of $\(displayBudget) dollars will reload in x days")
        var progress = 1.0-(amountLeftToSpend()/dataModel.settingsData.weeklyBudget)
        progressView.setProgress(Float(progress), animated: false)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
        )
    }
    
    func amountLeftToSpend ()->Double {
        var sum:Double = 0.0
        if let spendingDataArray = fetchedResultsController.fetchedObjects as? [SpendingData] {
            for spendingItem in spendingDataArray {
                sum = spendingItem.amountSpent + sum
                println("Spending Item .amountSpent\(spendingItem.amountSpent) and Spending Date date \(spendingItem.dateSpent)")
            }
        }
        let amountLeftInBudget = dataModel.settingsData.weeklyBudget - sum
        println("Amount Left in Budget is \(amountLeftInBudget)")
        return amountLeftInBudget
    }
    
    
    // Prepare for Segue, set up delegate
    override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?){
        if segue.identifier == "AddSpending" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddSpendingViewController
            controller.managedObjectContext = managedObjectContext
        } else if segue.identifier == "EditSpending"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddSpendingViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell){
                let spendingItem = fetchedResultsController.objectAtIndexPath(indexPath) as! SpendingData
                controller.itemToEdit = spendingItem
                }
            }
    }

    
    /////////////////////////////////////////////////////////
    //TableView Methods
    ////////////////////////////////////////////////////////
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeView")as! UITableViewCell
        let spendingItem = fetchedResultsController.objectAtIndexPath(indexPath) as! SpendingData
        configureTextForCell(cell, withSpendingItem: spendingItem)
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = fetchedResultsController.objectAtIndexPath(indexPath) as! SpendingData
            managedObjectContext.deleteObject(item)
            var error:NSError?
            if !managedObjectContext.save(&error) {
               fatalCoreDataError(error)
            }
        }
    }
    
    
    func configureTextForCell(cell:UITableViewCell, withSpendingItem spendingItem:SpendingData){
        cell.backgroundColor = UIColorFromRGB(0x4A4A4A)
        let category = cell.viewWithTag(1) as! UILabel
        let amountSpent = cell.viewWithTag(2) as! UILabel
        let dateSpent = cell.viewWithTag(3) as! UILabel
        
        category.text = spendingItem.category
        amountSpent.text = String(format:"%.2f",spendingItem.amountSpent)
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        dateSpent.text = formatter.stringFromDate(spendingItem.dateSpent!)
        category.font = UIFont(name:"Cochin", size:15)
        category.textColor = UIColorFromRGB(0xd7d7d7)
        amountSpent.font = UIFont(name:"Cochin", size:15)
        amountSpent.textColor = UIColorFromRGB(0xd7d7d7)
        dateSpent.font = UIFont(name:"Cochin", size:15)
        dateSpent.textColor = UIColorFromRGB(0xd7d7d7)
    }
}

extension HomeViewController:NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        println("*** ControllerWillChangeContent")
        tableView.beginUpdates()
    }
    func controller(controller:NSFetchedResultsController,didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                println("*** NSFetchedResultsChangeInsert (object)")
                tableView.insertRowsAtIndexPaths([newIndexPath!],
                withRowAnimation: .Fade)
            case .Delete:
                println("*** NSFetchedResultsChangeDelete (object)")
                tableView.deleteRowsAtIndexPaths([indexPath!],
                withRowAnimation: .Fade)
            case .Update:
                println("*** NSFetchedResultsChangeUpdate (object)")
                let cell = tableView.cellForRowAtIndexPath(indexPath!)
                let spendingItem = controller.objectAtIndexPath(indexPath!)as! SpendingData
                configureTextForCell(cell!, withSpendingItem: spendingItem)
            case .Move:
                println("*** NSFetchedResultsChangeMove (object)")
                tableView.deleteRowsAtIndexPaths([indexPath!],withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!],withRowAnimation: .Fade)
        }
    }
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                println("*** NSFetchedResultsChangeInsert (section)")
                tableView.insertSections(NSIndexSet(index: sectionIndex),withRowAnimation: .Fade)
            case .Delete:
                println("*** NSFetchedResultsChangeDelete (section)")
                tableView.deleteSections(NSIndexSet(index: sectionIndex),withRowAnimation: .Fade)
            case .Update:
                println("*** NSFetchedResultsChangeUpdate (section)")
            case .Move:
                println("*** NSFetchedResultsChangeMove (section)")
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
            println("*** controllerDidChangeContent")
            tableView.endUpdates()
    }
}



//    func checkDate(element:SpendingData)->Bool {
//         if weekStart?.compare(element.dateSpent)==NSComparisonResult.OrderedAscending && weekEnd?.compare(element.dateSpent)==NSComparisonResult.OrderedDescending {
//            return true
//        }
//        else {return false}
//    }
//
//CAN ALL BE DONE IN CORE DATA?
//    func predicateStuff(spendingDataAll:[SpendingData])->[SpendingData]{          //Send in current array of spending Data dataModel.spendingDataDisplay (array)
//        var dataToView = spendingDataAll.filter{ (element) in (self.weekStart?.compare(element.dateSpent)==NSComparisonResult.OrderedAscending && self.weekEnd?.compare(element.dateSpent)==NSComparisonResult.OrderedDescending) }
//        return dataToView
//    }


//    func addSpendingViewController(controller: AddSpendingViewController, didFinishAddingItem item: SpendingData) {
//        //let newRowIndex = dataModel.spendingDataDisplay.count
//        //let newRowIndex = calcNumberRows()
//
//        let newRowIndex = tableViewDataDisplay.count    //The number of viewable items.  This will be calculated in view did load
//        dataModel.spendingDataDisplay.append(item)      //Add the new item
//
//        if weekStart?.compare(item.dateSpent)==NSComparisonResult.OrderedAscending && weekEnd?.compare(item.dateSpent)==NSComparisonResult.OrderedDescending {  //If the new spending Item should be added to the tableView, insert a new row.  If it is not within the date range do nothing
//            tableViewDataDisplay = predicateStuff(dataModel.spendingDataDisplay)   //Returns updated array to display
//            let indexPath = NSIndexPath(forRow: newRowIndex, inSection:0)
//            let indexPaths = [indexPath]
//            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//        }
//
//        dismissViewControllerAnimated(true , completion: nil)
//        //dataModel.saveSpendingData()
//        (self.tabBarController as! MainTabBarController).dataModel = dataModel  //Push new values back to Tab Bar Controller
//    }




//    func updateTableViewData(){
//        tableViewDataDisplay = predicateStuff(dataModel.spendingDataDisplay)
//        tableView.reloadData()
//    }

//    func addSpendingViewController(controller:AddSpendingViewController, deleteSpending item:SpendingData){
//        if  let index = find(dataModel.spendingDataDisplay, item) {//Find the item in the Spending Data Array
//            let indexPath = NSIndexPath(forRow:index, inSection:0)
//            dataModel.spendingDataDisplay.removeAtIndex(indexPath.row)  //Delete from array
//            updateTableViewData()
////            let indexPaths = [indexPath]
////            tableView.deleteRowsAtIndexPaths(indexPaths,
////            withRowAnimation: .Automatic)
//        }
//        dismissViewControllerAnimated(true , completion: nil)
//        (self.tabBarController as! MainTabBarController).dataModel = dataModel  //Push new values back to Tab Bar Controller
//    }
//
//    func addSpendingViewController(controller:AddSpendingViewController, didFinishEditingItem item:SpendingData, atIndexPath indexPath:NSIndexPath){
////        if let cell = tableView.cellForRowAtIndexPath(indexPath) {  //references the cell that was originially selected
////                configureTextForCell(cell, withSpendingItem: item)
////            }
//        dataModel.spendingDataDisplay.removeAtIndex(indexPath.row)
//
//        dataModel.spendingDataDisplay.append(item)
//        updateTableViewData()
//        dismissViewControllerAnimated(true, completion: nil)
//        (self.tabBarController as! MainTabBarController).dataModel = dataModel  //Push new values back to Tab Bar Controller
//    }



//    func calcNumberRows ()->Int {   //NOTE : This is the only method that changes indexOffset
//        var count = 0
//        var indexCount=0 //Index to offset for viewing of current week's data
//        for itemToView in dataModel.spendingDataDisplay {
//            if weekStart?.compare(itemToView.dateSpent)==NSComparisonResult.OrderedAscending && weekEnd?.compare(itemToView.dateSpent)==NSComparisonResult.OrderedDescending {
//                count++
//                if (count == 1) {indexOffset = indexCount}    //Keep track of the first time the date falls in the week.  This is my offset.
//            }
//            indexCount++
//        }
//        println("Count is\(count)")
//        println("Index Offset is \(indexOffset)")
//        return count
//    }


//    //Swipe to delete
//    func tableView(tableView: UITableView,commitEditingStyle editingStyle: UITableViewCellEditingStyle,forRowAtIndexPath indexPath: NSIndexPath) {
//        // 1
//        //dataModel.spendingDataDisplay.removeAtIndex(indexPath.row)
//
//        let indexPaths = [indexPath]
//        let tempItem = tableViewDataDisplay[indexPath.row]
//            if  let findIndex = find(dataModel.spendingDataDisplay, tempItem) {//Find the item in the Spending Data Array and delete
//                let findIndexPath = NSIndexPath(forRow:findIndex, inSection:0)
//                dataModel.spendingDataDisplay.removeAtIndex(findIndexPath.row)
//            }
//        tableViewDataDisplay.removeAtIndex(indexPath.row)
//        self.tableView.deleteRowsAtIndexPaths(indexPaths,withRowAnimation: .Automatic)
//        (self.tabBarController as! MainTabBarController).dataModel = dataModel  //Push new values back to Tab Bar Controller
//    }



//    func weekStart(weekDaySelected:Int)->NSDate{
//        
//        let calendar = NSCalendar.currentCalendar()
//        var date = NSDate()
//        
//        //Get Today's Date at midnight
//        var todayComponents = calendar.components(.MonthCalendarUnit | .DayCalendarUnit | .YearCalendarUnit, fromDate: date)
//        todayComponents.hour = 00
//        todayComponents.minute = 00
//        let todayStart = calendar.dateFromComponents(todayComponents)
//        
//        //Get Current Weekday
//        let currentWeekday = calendar.components(.CalendarUnitWeekday, fromDate:date)
//        var weekDay = [currentWeekday.weekday]  //date component
//        println("Current weekday is \(weekDay[0])") //is 5
//        
//        var daysToSubtract = 0
//        if (weekDay[0]>=weekDaySelected) {
//            daysToSubtract = (weekDaySelected - weekDay[0]) //3
//        } else if (weekDay[0]<weekDaySelected){
//            daysToSubtract = (weekDaySelected-weekDay[0])-7
//        }
//        let dateComponents = NSDateComponents()
//        dateComponents.day = daysToSubtract
//        
//        var startDate = calendar.dateByAddingComponents(dateComponents, toDate: todayStart!, options: nil)
//        return startDate!   //Return the start of a 7 Day Week
//        //    //println("Start Date is \(startDate)")
//        //    let formatter = NSDateFormatter()
//        //    formatter.dateStyle = .MediumStyle
//        //    formatter.timeStyle = .LongStyle
//        //    println("Date of start of week is \(formatter.stringFromDate(startDate!))")
//        
//    }
//
//
//if let indexPath = self.tableView.indexPathForSelectedRow(){    //Index path selected
//                var selectedItem = fetchedResultsController.objectAtIndexPath(indexPath) as! SpendingData  //selectedItem = item in row user selected
//
////                if  let index = find(dataModel.spendingDataDisplay, selectedItem){ //Find the selected item in the original data array
//                    let indexPathToSend = NSIndexPath(forRow:index, inSection:0)
//                    controller.itemToEdit = selectedItem
//                    controller.indexToEdit = indexPathToSend  //Send index from data array because this will have to be updated!
//                }
//
