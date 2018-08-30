//
//  NewUserViewController.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/19/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import Eureka

class NewUserViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("General")
            
            <<< TextRow() {row in
                row.tag = "firstname"
                row.title = "First Name"
                row.placeholder = "Bobby"
            }
            
            <<< TextRow() {row in
                row.tag = "lastname"
                row.title = "Last Name"
                row.placeholder = "Legend"
            }
        
            <<< ButtonRow() {row in
                row.title = "Submit"
            }.onCellSelection({ (cell, row) in
                let valuesDictionary = self.form.values()
                if (valuesDictionary["firstname"]!) != nil && (valuesDictionary["lastname"]!) != nil {
                    if !(valuesDictionary["firstname"] as! String).contains(" ") && !(valuesDictionary["lastname"] as! String).contains(" ") {
                        self.submitForm(firstName: (valuesDictionary["firstname"] as! String), lastName: (valuesDictionary["lastname"] as! String))
                    }
                }
            })
    }
    
    func submitForm(firstName : String, lastName : String) {
        print("Form completed, writing to database and moving to workout view controller")
        workoutUser = firstName + " " + lastName
        let documentName = (firstName + lastName).lowercased()
        // Add a new document in collection "users"
        db.collection("users").document(documentName).setData([
            "First": firstName,
            "Last": lastName
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        self.performSegue(withIdentifier: "StartWorkout", sender: self)
    }
    
}
