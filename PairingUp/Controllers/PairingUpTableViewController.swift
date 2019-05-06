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
    
    @IBOutlet weak var randomizeButtonOutlet: UIButton!
    
    
    // MARK: - ViewController Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        if PersonModelController.shared.persons.count < 2 {
            
            randomizeButtonOutlet.isEnabled = false
            
        } else {
            
            randomizeButtonOutlet.isEnabled = true
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addPersonButtonTapped(_ sender: UIBarButtonItem) {
        createAlert()
        // ^^ this function is found int the helper function extension below
    }
    
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        createRandomPairs()
        // ^^ this function is found int the helper function extension below
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeaderView = UIView()
        sectionHeaderView.backgroundColor = UIColor.white
        
        let avenirFont16 = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16)! ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: sections[section], attributes: avenirFont16)
        label.frame = CGRect(x: 16, y: 0, width: 200, height: 40)
        
        sectionHeaderView.addSubview(label)
        
        return sectionHeaderView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
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
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath) as? PairTableViewCell else {
                
                print("ERROR: there was an error where a nil vlaue was found when creating the PairTableViewCell in PairingUpTableViewController.swift -> tableView(cellForRowAt:) - line 64.")
                return UITableViewCell()
            }
            
            cell.person = PersonModelController.shared.persons[indexPath.row]
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath) as? PairTableViewCell else {
                
                print("ERROR: there was an error where a nil vlaue was found when creating the PairTableViewCell in PairingUpTableViewController.swift -> tableView(cellForRowAt:) - line 64.")
                return UITableViewCell()
            }
            
            cell.pair = pairs[indexPath.section - 1]
            
            return cell
        }
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
            
            // set the randomize button to disabled if there are no people to pair
            if PersonModelController.shared.persons.count < 2 {
                
                randomizeButtonOutlet.isEnabled = false
            }
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
                
                if PersonModelController.shared.persons.count >= 2 {
                    
                    self.randomizeButtonOutlet.isEnabled = true
                }
                
            } else {
                
                return
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createRandomPairs() {
        
        pairs = []
        
        sections = ["people to be paired up"]
        
        var people = PersonModelController.shared.persons
        
        var pairCounter = 0
        
        if people.count >= 2 {
            
            people.shuffle()
            
            for person in people {
                
                pairs.append([person])
                
                pairCounter += 1
                
                let newSectionName = "Pair \(pairCounter)"
                
                sections.append(newSectionName)
                
                tableView.reloadData()
                
            }
        }
    }

}
