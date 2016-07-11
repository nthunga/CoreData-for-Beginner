//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Naveen Thunga on 11/07/16.
//  Copyright © 2016 My Labs. All rights reserved.
//

import Foundation
import CoreData

private let fetchBatchSize = 20

public let NSRangeZero = NSMakeRange(0, 0)

extension NSManagedObjectContext {
    
    func fetch<T: NSManagedObject>(entity: T.Type, filter: String? = nil, sort: [NSSortDescriptor]? = nil, range: NSRange = NSRangeZero) -> [T]? {
        let fetchRequest = NSFetchRequest(entityName: entity.entityName)
        fetchRequest.fetchBatchSize = fetchBatchSize
        fetchRequest.fetchOffset = range.location
        fetchRequest.fetchLimit = range.length
        
        if let filter = filter {
            let predicate = NSPredicate(format: filter)
            fetchRequest.predicate = predicate
        }
        
        if let sort = sort {
            fetchRequest.sortDescriptors = sort
        }
        
        let result = try! self.executeFetchRequest(fetchRequest)
        
        return result as? [T]
    }
    
    func firstObject<T: NSManagedObject>(entity: T.Type, filter: String? = nil, sort: [NSSortDescriptor]? = nil) -> T? {
        let result = fetch(entity, filter: filter, sort: sort, range: NSMakeRange(0, 1));
        
        if let unrappedResult = result {
            return unrappedResult.first
        }
        return nil
    }
    
    func fetchDuplicateObject<T: NSManagedObject>(type: T.Type,primaryKeyValue:String?)-> T?
    {
        let fetchRequest = NSFetchRequest(entityName: type.entityName)
        fetchRequest.fetchOffset = 0
        fetchRequest.fetchLimit = 1
        if let unwrappedPrimaryKeyValue = primaryKeyValue
        {
            fetchRequest.predicate = NSPredicate(format: "name == %@",unwrappedPrimaryKeyValue)
        }
        let result = try! self.executeFetchRequest(fetchRequest)
        if result.count > 0 {
            if let object = result.first{
                return object as? T
            }
        }
        return nil;
    }
    
//    func fetchProjects<T: NSManagedObject>(entity: T.Type, sort: [NSSortDescriptor]? = nil, range: NSRange = NSRangeZero)-> [T]?
//    {
//        let fetchRequest = NSFetchRequest(entityName: entity.entityName)
//        fetchRequest.fetchBatchSize = fetchBatchSize
//        fetchRequest.fetchOffset = range.location
//        fetchRequest.fetchLimit = range.length
//        
//        let predicate = NSPredicate(format: "isActive == true")
//        fetchRequest.predicate = predicate
//        
//        if let sort = sort {
//            fetchRequest.sortDescriptors = sort
//        }
//        
//        let result = try! self.executeFetchRequest(fetchRequest)
//        
//        return result as? [T]
//    }

}



