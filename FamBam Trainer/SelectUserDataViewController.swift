//
//  SelectUserDataViewController.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/20/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import UIKit

// public variables
public var userNameData : String = ""

class SelectUserDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // instance variables
    var userNames = [String]()
    var usersTableView: UITableView! // table to display user names
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setUpTable()
    }
    
    func setUserNames(userArr : [String]) {
        self.userNames = userArr
    }
    
    func setUpTable() {
        
        DatabaseMethods.getUsers {
            users in
            self.setUserNames(userArr: users);
            //update table when async call completes
            self.usersTableView.reloadData();
        }
        
        // dropdown content
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = UIScreen.main.bounds.width
        let displayHeight: CGFloat = UIScreen.main.bounds.height
        
        usersTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight))
        usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.separatorColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(usersTableView)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selects \(userNames[indexPath.row])")
        userNameData = userNames[indexPath.row]
        self.performSegue(withIdentifier: "ShowData", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(userNames[indexPath.row])"
        cell.textLabel!.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        return cell
    }
    
    override func viewDidLoad() {
        // Create a navView to add to the navigation bar
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "Select User"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
        // Add both the label and image view to the navView
        navView.addSubview(label)
        
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        
        // change colors of nav bar
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
        
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
    }
    
    
}
