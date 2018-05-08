//
//  SomeModuleDatabaseModel.swift
//  Demo
//
//  Created by Siarhei Ladzeika.
//  Copyright © 2018-present Siarhei Ladzeika. All rights reserved.
//

import Foundation
import CacheTracker
import CoreData

class SomeModuleDatabaseModel: NSManagedObject, CacheTrackerDatabaseModel {
    
    // MARK: CacheTrackerDatabaseModel
    
    static func entityName() -> String {
        return NSStringFromClass(self)
    }
    
    func toPlainModel<P>() -> P? {
        return SomeModuleEntityModel() as? P
    }
    
    class func somePredicate() -> NSPredicate {
        return NSPredicate(value: true)
    }
    
    class func someSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "a", ascending: true)
        ]
    }
    
}


