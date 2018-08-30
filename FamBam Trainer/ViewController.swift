//
//  ViewController.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/16/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import UIKit
import CoreBluetooth

var btManager : CBCentralManager!

class ViewController: UIViewController, CBCentralManagerDelegate{

    var bluetoothOn = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiate bluetooth manager
        btManager = CBCentralManager(delegate: self, queue: nil)
        
        // Start workout button initialization
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2))
        let stopwatchImage = UIImage(named: "Stopwatch")!.alpha(0.2)
        button.setBackgroundImage(stopwatchImage, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 0.2)
        button.setTitle("Start Workout", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 35)
        button.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.layer.cornerRadius = 0
        self.view.addSubview(button)
        
        // View user data button initialization
        let userDataButton = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2))
        let chartImage = UIImage(named: "Chart")!.alpha(0.2)
        userDataButton.setBackgroundImage(chartImage, for: .normal)
        userDataButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.2)
        userDataButton.setTitle("Workout History", for: .normal)
        userDataButton.titleLabel?.font =  .boldSystemFont(ofSize: 35)
        userDataButton.setTitleColor(#colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1), for: .normal)
        userDataButton.addTarget(self, action: #selector(userDataButtonClick), for: .touchUpInside)
        userDataButton.layer.cornerRadius = 0
        self.view.addSubview(userDataButton)
    }
    
    @objc func userDataButtonClick(sender: UIButton!) {
        print("Moving to user selection for workout data")
        self.performSegue(withIdentifier: "SelectUserData", sender: self)
    }
    
    @objc func buttonClick(sender: UIButton!) {
        print("Workout starting")
        capturePackets()
    }
    
    func capturePackets() {
        if(bluetoothOn){
            // move to select user view controller
            print("BT on, moving to select user view controller")
            self.performSegue(withIdentifier: "SelectUser", sender: self)
        } else {
            //display pop up with message
            print("BT not on, displaying alert")
            popUp(message: "Issue connecting with bluetooth. Make sure your bluetooth is turned on.")
        }
    }
    
    
    // check status of bt manager
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == CBManagerState.poweredOn) {
            print("BT connection exists")
            bluetoothOn = true
        } else {
            print("BT connection not found")
            bluetoothOn = false
        }
    }

    // popUp to be displayed on BT connection failure.
    func popUp(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

// UIImage extension for transparency (alpha) of images
// use like: let img = UIImage(named: "imageWithoutAlpha")!.alpha(0.5)
// credit (S.O): Peter Kreinz
extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

