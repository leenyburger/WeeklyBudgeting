//
//  SpendingData.swift
//  WeeklyBudgeting
//
//  Created by silveroak on 2/11/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import Foundation

class SpendingData:NSObject, NSCoding {
    
    var amountSpent:Double = 0.0
    var category : String = ""
    var dateSpent = NSDate()
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(category, forKey: "Category")
        aCoder.encodeDouble(amountSpent, forKey: "AmountSpent")
        aCoder.encodeObject(dateSpent, forKey: "DateSpent")
    }
    required init(coder aDecoder:NSCoder){
        category=aDecoder.decodeObjectForKey("Category")as! String
        amountSpent = aDecoder.decodeDoubleForKey("AmountSpent")
        dateSpent = aDecoder.decodeObjectForKey("DateSpent") as! NSDate
        super.init()
    }
    override init() {
        super.init()
    }
}

