//
//  PairingUpTableViewController.swift
//  PairingUp
//
//  Created by Michael Guatambu Davis on 5/5/19.
//  Copyright © 2019 DunDak, LLC. All rights reserved.
//

import UIKit

class PairingUpTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var sections = ["people to be paired up"]
    
    var pairs: [[Person]] = []
    
    
    // MARK: - ViewController Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Actions
    
    @IBAction func addPersonButtonTapped(_ sender: UIBarButtonItem) {
        
        createAlert()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            // return the total list of people the user has added to their pairing list
            return PersonModelController.shared.persons.count
            
        } else {
            // there will only be one pair returned for each section, with each section showing a randomly generated pair
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath) as? PairTableViewCell else {
            
            print("ERROR: there was an error where a nil vlaue was found when creating the PairTableViewCell in PairingUpTableViewController.swift -> tableView(cellForRowAt:) - line 64.")
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            
            cell.person = PersonModelController.shared.persons[indexPath.row]
        }
 
        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the person from the data source of truth
            PersonModelController.shared.delete(person: PersonModelController.shared.persons[indexPath.row])
            // Delete the row from the tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}


// MARK: - Helper Functions
extension PairingUpTableViewController {
    
    func createAlert() {
        
        let alert = UIAlertController(title: "Add Person", message: "this person will be used for pairing up", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enter a person's name"        }
        
        let cancel = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let add = UIAlertAction(title: "add", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            
            guard let textField =  alert.textFields?.first else {
                print("ERROR: no UITextField found in alert in PersonTableViewController.swift -> createAlert() - line 91.")
                return
            }
            
            if textField.text != "" {
                
                let person = Person(name: textField.text ?? "")
                
                PersonModelController.shared.add(person: person)
                
                self.tableView.reloadData()
                
            } else {
                
                return
            }
        }
        
        
        alert.addAction(cancel)
        alert.addAction(add)
    }
    
}
