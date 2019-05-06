//
//  Person+Convenience.swift
//  PairingUp
//
//  Created by Michael Guatambu Davis on 5/5/19.
//  Copyright © 2019 DunDak, LLC. All rights reserved.
//

import Foundation
import CoreData


extension Person {
    
    // convenience initializer to allow creation of a Person object via CoreDataStack's managedObjectContext
    convenience init(name: String,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
    }
}
