//
//  PersonModelController.swift
//  PairingUp
//
//  Created by Michael Guatambu Davis on 5/5/19.
//  Copyright © 2019 DunDak, LLC. All rights reserved.
//

import Foundation
import CoreData

class PersonModelController {
    
    // MARK: - Properties
    
    static let shared = PersonModelController()
    
    var persons: [Person] {
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            return try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            print("ERROR: there was an error fetching owners. \(error) \(error.localizedDescription)")
            return []
        }
        
    }
    
    // MARK: - CRUD Funcitons
    
    // Create
    func add(person: Person) {
        saveToPersistentStorage()
    }
    
    // Update
    func update(person: Person, name: String) {
        person.name = name
        
        saveToPersistentStorage()
    }
    
    // Delete
    func delete(person: Person) {
        
        if let moc = person.managedObjectContext {
            
            moc.delete(person)
            saveToPersistentStorage()
        }
    }
    
    
    // MARK: - SaveToPersistentStore()
    func saveToPersistentStorage() {
        
        do {
            try CoreDataStack.context.save()
        } catch {
            print("ERROR: there was an error saving to persitent store. \(error) \(error.localizedDescription)")
        }
    }
}
