//
//  DataModel.swift
//  WeeklyBudgeting
//
//  Created by Schnettler Family on 3/5/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import Foundation

class DataModel {
    var settingsData = SettingsData()
    
    init(){
        loadSettingsData()
        println("After load spending data")
    }
    
    func loadSettingsData(){
        let path = dataFilePath()
        println("Data File Path trying to load data\(path)")
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            println("file exists at path")
            if let data = NSData(contentsOfFile:path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                settingsData = unarchiver.decodeObjectForKey("SettingsData") as! SettingsData
                unarchiver.finishDecoding()
            }
        }
        println("Settings Data is : \(self.settingsData.weeklyBudget)")
    }
    
    func saveSettingsData (){   //Writes settingsData to to .plist 
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(settingsData, forKey:"SettingsData")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically:true)
        println("Saving Settings Data")
    }
    
    func documentsDirectory()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    func dataFilePath()->String{
        return documentsDirectory().stringByAppendingPathComponent("WeeklyBudgeting.plist")
    }

    
   
}
