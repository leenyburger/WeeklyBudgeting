//
//  HistoryViewController.swift
//  WeeklyBudgeting
//
//  Created by silveroak on 2/9/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import UIKit
class HistoryViewController:UIViewController
{}

//class HistoryViewController: UIViewController,CPTPlotDataSource, UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var graphView: CPTGraphHostingView!
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    var spendingDataDisplay: [SpendingData]  //The array of spending data to be displayed
//
//    
//    //Initialization of data to view.  This information comes from the SpendingData Model.
//    required init(coder aDecoder: NSCoder) {
//        spendingDataDisplay = [SpendingData]()  //Instantiate the array object
//        
//        let row0item = SpendingData()
//        row0item.amountSpent = 5.0
//        row0item.category = "Target"
//        row0item.dateSpent = NSDate()
//        spendingDataDisplay.append(row0item)
//        
//        super.init(coder: aDecoder)
//    }
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib. // create graph
//        var graph = CPTXYGraph(frame: CGRectZero)
//        graph.title = "Hello Graph"
//        graph.paddingLeft = 0
//        graph.paddingTop = 0
//        graph.paddingRight = 0
//        graph.paddingBottom = 0
//        // hide the axes
//        var axes = graph.axisSet as! CPTXYAxisSet
//        var lineStyle = CPTMutableLineStyle()
//        lineStyle.lineWidth = 0
//        axes.xAxis.axisLineStyle = lineStyle
//        axes.yAxis.axisLineStyle = lineStyle
//        
//        // add a pie plot
//        var pie = CPTPieChart()
//        pie.dataSource = self
//        pie.pieRadius = (self.view.frame.size.width * 0.9)/2
//        graph.addPlot(pie)
//        
//        self.graphView.hostedGraph = graph
//    }
//    
//    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
//        return 4
//    }
//    
//    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> NSNumber! {
//        return idx+1
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    //TableView Methods
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return spendingDataDisplay.count }
//    
//    func tableView(tableView: UITableView,
//        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("SpendingItem")
//        as! UITableViewCell
//            
//        let spendingItem = spendingDataDisplay[indexPath.row]  //Type of SpendingData
//        configureTextForCell(cell, withSpendingItem: spendingItem)
//        return cell
//    }
//    
//    func configureTextForCell(cell:UITableViewCell, withSpendingItem spendingItem:SpendingData){
//        let category = cell.viewWithTag(100) as! UILabel
//        let amountSpent = cell.viewWithTag(200) as! UILabel
//        let dateSpent = cell.viewWithTag(300)as! UILabel
//        
//        category.text = spendingItem.category
//        amountSpent.text = String(format:"%f",spendingItem.amountSpent)
//        let formatter = NSDateFormatter()
//        formatter.dateStyle = .MediumStyle
//        formatter.timeStyle = .ShortStyle
//        dateSpent.text = formatter.stringFromDate(spendingItem.dateSpent!)
//
//    }
//}
