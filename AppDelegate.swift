//
//  AppDelegate.swift
//  WeeklyBudgeting
//
//  Created by silveroak on 2/9/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import UIKit
import CoreData

let MyManagedObjectContextSaveDidFailNotification = "MyManagedObjectContextSaveDidFailNotification"

func fatalCoreDataError(error: NSError?) {
    if let error = error {
        println("*** Fatal error: \(error), \(error.userInfo)")
    }
    NSNotificationCenter.defaultCenter().postNotificationName(MyManagedObjectContextSaveDidFailNotification, object: error)
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let dataModel = DataModel()
    lazy var managedObjectContext: NSManagedObjectContext = {
        if let modelURL = NSBundle.mainBundle().URLForResource("DataModel",withExtension: "momd") {
            if let model = NSManagedObjectModel(contentsOfURL: modelURL) as NSManagedObjectModel! {
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel:model)
                let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
                let documentsDirectory = urls[0] as! NSURL
                let storeURL = documentsDirectory.URLByAppendingPathComponent("DataStore.sqlite")
                var error :NSError?
                if let store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) {
                    let context = NSManagedObjectContext()
                context.persistentStoreCoordinator = coordinator
                    println(storeURL)
                return context
                } else {
                    println("Error adding persistent store at \(storeURL): \(error!)")
                }
            } else {
                    println("Error initializing model from: \(modelURL)")
                }
            } else {
                    println("Could not find data model in app bundle")
            }
     
            abort()
    }()
    
    var window: UIWindow?
  
    
       
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
                    let tabBarController = window!.rootViewController as! UITabBarController    //Find the tab bar controller
        
                    //tabBarController.delegate = self    //Make the app delegate the tab Bar Controller delegate
        
                    if let tabBarViewControllers = tabBarController.viewControllers {
                        let navigationController = tabBarViewControllers[0] as! UINavigationController //Access the navigation controller of the first view controller
                        let homeViewController = navigationController.viewControllers[0] as! HomeViewController
                        homeViewController.managedObjectContext = managedObjectContext
                        homeViewController.dataModel = dataModel
                        
//                        let HistoryViewController = navigationController.viewControllers[2] as! HistoryViewController
//                        historyViewController.managedObjectContext = managedObjectContext
//                        historyViewController.dataModel = dataModel
                        let navController = tabBarViewControllers[2] as! UINavigationController
                        let settingsTableViewController = navController.viewControllers[0] as! SettingsTableViewController
                        settingsTableViewController.dataModel = dataModel
                    }
        listenForFatalCoreDataNotifications()
        return true
    }
    func listenForFatalCoreDataNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(MyManagedObjectContextSaveDidFailNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            let alert = UIAlertController(title: "Internal Error",
                message: "There was a fatal error in the app and it cannot continue.\n\n"
                    + "Press OK to terminate the app. Sorry for the inconvenience.",
                preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                let exception = NSException(name: NSInternalInconsistencyException, reason: "Fatal Core Data error", userInfo: nil)
                exception.raise()
            }
            
            alert.addAction(action)
            
            self.viewControllerForShowingAlert().presentViewController(alert, animated: true, completion: nil)
        })
    }
       
    func viewControllerForShowingAlert() -> UIViewController {
        let rootViewController = self.window!.rootViewController!
        if let presentedViewController = rootViewController.presentedViewController {
            return presentedViewController
        } else {
            return rootViewController
            }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        saveData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
//        updateBudget()
            }

    func applicationWillTerminate(application: UIApplication) {
        saveData()
    }

    func saveData(){
        dataModel.saveSettingsData()
          }
    
//    func updateBudget() {
//        var resetBudget = dataModel.settingsData.checkWeekday() //Check to see if the budget needs to be reset
//        if (resetBudget == true) {
//            let tempBudget = dataModel.settingsData.weeklyBudget
//            dataModel.settingsData.weeklyBudget = tempBudget
//            let tabBarController = window!.rootViewController as MainTabBarController
//            tabBarController.dataModel = dataModel  //Send Data Model to Tab Bar Controller
//        }
//
//    }

}

