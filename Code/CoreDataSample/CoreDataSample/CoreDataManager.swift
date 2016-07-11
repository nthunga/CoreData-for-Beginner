//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Naveen Thunga on 11/07/16.
//  Copyright © 2016 My Labs. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ymedialabs.CauzColony" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CoreDataSample", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            abort()
        }
        
        return coordinator
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
      managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    var  writeContext: NSManagedObjectContext {
        //for now its commented, need to change the implementation to reflt
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext =  CoreDataManager.sharedInstance.mainContext
        return context
    }
}

// MARK: - NSManagedObject
extension NSManagedObject {
    
    public class var entityName: String {
        let fullClassName = NSStringFromClass(self)
        
        let classComponent = fullClassName.componentsSeparatedByString(".")
        
        let className = classComponent.last
        
        return className!
    }
    convenience init(context:NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(self.dynamicType.entityName, inManagedObjectContext: context)
        self.init(entity: entity!,insertIntoManagedObjectContext: context)
    }
}


// MARK: - NSManagedObjectContext

extension NSManagedObjectContext {
    
    func commit(wait wait: Bool = false, completion: (() -> ())? = nil) {
        let colsure = {
            try! self.save()
            
            if let parent = self.parentContext {
                parent.commit(wait: wait, completion: completion)
            }
            else {
                if let completion = completion {
                    completion()
                }
            }
        }
        if wait {
            self.performBlockAndWait(colsure)
        }
        else {
            self.performBlock(colsure)
        }
    }
}


