//
//  Teacher+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Naveen Thunga on 11/07/16.
//  Copyright © 2016 My Labs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Teacher {

    @NSManaged var name: String?
    @NSManaged var id: String?
    @NSManaged var subjects: [String]?
    @NSManaged var school: School?

}
