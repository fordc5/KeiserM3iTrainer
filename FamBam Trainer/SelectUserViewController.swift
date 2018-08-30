//
//  SelectUserViewController.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/17/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//
import UIKit

// public variables
public var workoutUser : String = ""

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // user content
    var users = [String]()
    
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change colors of nav bar
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
        
        setUpDropdown()
    }
    
    func setUserNames(userArr : [String]) {
        self.users = userArr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        DatabaseMethods.getUsers {
            users in
            self.setUserNames(userArr: users);
            //update table when async call completes
            self.myTableView.reloadData();
        }
    }
    
    
    func setUpDropdown() {
        
        // user dropdown button
        let dropdownButton = UIButton()
        dropdownButton.frame = CGRect(x: 25, y: 50, width: UIScreen.main.bounds.width - 50, height: 50)
        dropdownButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropdownButton.layer.borderWidth = 3.0
        dropdownButton.layer.cornerRadius = 5
        dropdownButton.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        dropdownButton.setTitle("Select User", for: .normal)
        dropdownButton.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1), for: .normal)
        dropdownButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(dropdownButton)
        
        
        myTableView = UITableView(frame: CGRect(x: 25, y: 100, width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 64 - 100 - 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.isHidden = true
        self.view.addSubview(myTableView)
        
        
        // new user label and button
        let newUserLabel = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 80 - 64, width: UIScreen.main.bounds.width, height: 30))
        newUserLabel.text = "Dont see your user? Create one."
        newUserLabel.textAlignment = .center
        newUserLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        self.view.addSubview(newUserLabel)
        
        
        let newUserButton = UIButton()
        newUserButton.frame = CGRect(x: (UIScreen.main.bounds.width/2) - 50, y: UIScreen.main.bounds.height - 50 - 64, width: 100, height: 40)
        newUserButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        newUserButton.layer.borderWidth = 2.0
        newUserButton.layer.cornerRadius = 5
        newUserButton.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        newUserButton.setTitle("New User", for: .normal)
        newUserButton.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1), for: .normal)
        newUserButton.addTarget(self, action: #selector(newUserAction), for: .touchUpInside)
        self.view.addSubview(newUserButton)

    }
    
    // button listener
    @objc func buttonAction(sender: UIButton!) {
        print("Display users")

        myTableView.isHidden = false
    }
    
    // button listener
    @objc func newUserAction(sender: UIButton!) {
        print("New user button selected, moving to new user view controller")
        self.performSegue(withIdentifier: "NewUser", sender: self)
    }
    
    // on user select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selects \(users[indexPath.row])")
        workoutUser = users[indexPath.row] as! String
        self.performSegue(withIdentifier: "StartWorkout", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(users[indexPath.row])"
        return cell
    }
    
    
}
