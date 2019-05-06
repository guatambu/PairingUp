//
//  PairTableViewCell.swift
//  PairingUp
//
//  Created by Michael Guatambu Davis on 5/5/19.
//  Copyright © 2019 DunDak, LLC. All rights reserved.
//

import UIKit

class PairTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var person1LabelOutlet: UILabel!
    @IBOutlet weak var person2LabelOutlet: UILabel!
    
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    var pair: (Person, Person)? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - Helper Functions
    func updateViews() {
        
        if let person = person {
            
            person1LabelOutlet.text = person.name ?? ""
            
            person2LabelOutlet.text = ""
            
        }
        
        if let pair = pair {
            
            person1LabelOutlet.text = pair.0.name ?? ""
            
            person2LabelOutlet.text = pair.1.name ?? ""
        }
    }
}
