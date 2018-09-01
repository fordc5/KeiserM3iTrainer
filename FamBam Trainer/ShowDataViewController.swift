//
//  ShowDataViewController.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/20/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import UIKit
import Firebase

struct PositioningConstants {
    let NAV_BAR_HEIGHT : Int
    let SCREEN_WIDTH : Int
    let PB_HEIGHTS : Int
    let USERNAME_Y : Int
    let USERNAME_HEIGHT : Int
    let PB_HEADER_Y : Int
    let PB_HEADER_HEIGHT : Int
    let MAX_Y : Int
    let THIRTY_Y : Int
    let ONE_Y : Int
    let TEN_Y : Int
    let WORKOUTS_HEADER_Y : Int
    let WORKOUTS_HEADER_HEIGHT : Int
    let WORKOUTS_Y : Int
    let WORKOUTS_HEIGHT : Int
    
    
    init() {
        NAV_BAR_HEIGHT = 0
        SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
        PB_HEIGHTS = 30
        USERNAME_Y = NAV_BAR_HEIGHT
        USERNAME_HEIGHT = 50
        PB_HEADER_Y = USERNAME_Y + USERNAME_HEIGHT + 10
        PB_HEADER_HEIGHT = 30
        MAX_Y = PB_HEADER_Y + PB_HEADER_HEIGHT
        THIRTY_Y = MAX_Y + PB_HEIGHTS
        ONE_Y = THIRTY_Y + PB_HEIGHTS
        TEN_Y = ONE_Y + PB_HEIGHTS
        WORKOUTS_HEADER_Y = TEN_Y + PB_HEIGHTS + 15
        WORKOUTS_HEADER_HEIGHT = 30
        WORKOUTS_Y = WORKOUTS_HEADER_Y + WORKOUTS_HEADER_HEIGHT
        WORKOUTS_HEIGHT = Int(UIScreen.main.bounds.height) - WORKOUTS_Y - 64
    }
}


//Public variables
public var workoutSelected = ""
public var docKey = ""

class ShowDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userData : [String: Any] = [:]
    var userName = "", first = "", last = ""
    
    var userNameLabel = UILabel()
    
    var userPBHeaderLabel = UILabel()
    let userPBHeaderLabelText = "PERSONAL BESTS (watts)"
    
    let userPBNewRecordLabelText = "New Record!"
    
    var userPBMaxLabel = UILabel()
    var userPBMaxHeaderLabel = UILabel()
    let userPBMaxHeaderLabelText = "Max"
    var userPBMaxNewRecordLabel = UILabel()
    
    var userPBThirtyLabel = UILabel()
    var userPBThirtyHeaderLabel = UILabel()
    let userPBThirtyHeaderLabelText = "Thirty Seconds"
    var userPBThirtyNewRecordLabel = UILabel()
    
    var userPBOneLabel = UILabel()
    var userPBOneHeaderLabel = UILabel()
    let userPBOneHeaderLabelText = "One Minute"
    var userPBOneNewRecordLabel = UILabel()
    
    var userPBTenLabel = UILabel()
    var userPBTenHeaderLabel = UILabel()
    let userPBTenHeaderLabelText = "Ten Minutes"
    var userPBTenNewRecordLabel = UILabel()
    
    var userWorkoutsHeaderLabel = UILabel()
    let userWorkoutsHeaderLabelText = "MY WORKOUTS"
    
    var userWorkoutsTableView = UITableView()
    
    var workouts = [String]() //initialize array for workout history
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        print("Data view loading for user: \(userNameData)")
        
        // get user data
        userName = userNameData
        first = String(userName.split(separator: " ")[0])
        last = String(userName.split(separator: " ")[1])
        docKey = "\(first)\(last)".lowercased()
        
        DatabaseMethods.getUserData(key: docKey) {
            data in
            self.setPBLabels(data: data);
            self.checkNewRecords(data: data);
            self.setWorkouts(data: data);
            self.userWorkoutsTableView.reloadData();
        }
        userNameLabel.text = "\(first) \(last)"
    }
    
    func setPBLabels(data : [String : Any]) {
        if data["PBs"] != nil {
            let PBs : NSDictionary = data["PBs"] as! NSDictionary
            let max = (PBs["Max"] as! NSDictionary)["watts"]!
            let tenmin = (PBs["10Minute"] as! NSDictionary)["watts"]!
            let onemin = (PBs["1Minute"] as! NSDictionary)["watts"]!
            let thirtysec = (PBs["30Second"] as! NSDictionary)["watts"]!
            
            userPBMaxLabel.text = "\(max)"
            userPBThirtyLabel.text = "\(thirtysec)"
            userPBOneLabel.text = "\(onemin)"
            userPBTenLabel.text = "\(tenmin)"
        }
    }
    
    func checkNewRecords(data: [String : Any]) {
        if data["PBs"] != nil {
            let timestamp = NSDate().timeIntervalSince1970
            let myTimeInterval = TimeInterval(timestamp)
            let currentTime = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
            let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let PBs = data["PBs"] as! NSDictionary
            let maxWorkoutName = (PBs["Max"] as! NSDictionary)["workout"] as! String
            let tenminWorkoutName = (PBs["10Minute"] as! NSDictionary)["workout"] as! String
            let oneminWorkoutName = (PBs["1Minute"] as! NSDictionary)["workout"] as! String
            let thirtysecWorkoutName = (PBs["30Second"] as! NSDictionary)["workout"] as! String
            
            if (maxWorkoutName != "") {
                let maxDate = ((data[maxWorkoutName] as! NSDictionary)["Timestamp"] as! Timestamp).dateValue()
                let maxDifference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: maxDate, to: currentTime as Date)
                let maxDifferenceDays = maxDifference.day!
                
                if maxDifferenceDays <= 2 {
                    self.userPBMaxNewRecordLabel.isHidden = false
                } else {
                    print("New max watts record, displaying alert")
                }
            }
            
            if (tenminWorkoutName != "") {
                let tenMinDate = ((data[tenminWorkoutName] as! NSDictionary)["Timestamp"] as! Timestamp).dateValue()
                let tenMinDifference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: tenMinDate, to: currentTime as Date)
                let tenMinDifferenceDays = tenMinDifference.day!
                
                if tenMinDifferenceDays <= 2 {
                    self.userPBTenNewRecordLabel.isHidden = false
                } else {
                    print("New ten minute watts record, displaying alert")
                }
            }
            
            if (oneminWorkoutName != "") {
                let oneMinDate = ((data[oneminWorkoutName] as! NSDictionary)["Timestamp"] as! Timestamp).dateValue()
                let oneMinDifference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: oneMinDate, to: currentTime as Date)
                let oneMinDifferenceDays = oneMinDifference.day!
                
                if oneMinDifferenceDays <= 2 {
                    self.userPBOneNewRecordLabel.isHidden = false
                } else {
                    print("New one minute watts record, displaying alert")
                }
            }
            
            if (thirtysecWorkoutName != "") {
                let thirtySecDate = ((data[thirtysecWorkoutName] as! NSDictionary)["Timestamp"] as! Timestamp).dateValue()
                let thirtySecDifference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: thirtySecDate, to: currentTime as Date)
                let thirtySecDifferenceDays = thirtySecDifference.day!
                
                if thirtySecDifferenceDays <= 2 {
                    self.userPBThirtyNewRecordLabel.isHidden = false
                } else {
                    print("New thirty second watts record, displaying alert")
                }
            }
        }
    }
    
    func setWorkouts(data : [String : Any]) {
        var tempArr = [String]()
        let keys = data.keys
        for key in keys {
            if (key).contains("workout") {
                let workoutNum = key.dropFirst(7)
                let date = ((data[key] as! NSDictionary)["Timestamp"] as! Timestamp).dateValue()
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd, yyyy"
                let parsedDate = dateFormatterPrint.string(from: date)
                let time = ((((data[key] as! NSDictionary)["wattdata"] as! [[String : NSNumber]]).last as! [String: NSNumber])["time"] as! NSNumber)
                let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(time))
                tempArr.append("Workout #\(workoutNum) on \(parsedDate)  |  \(h)h \(m)m \(s)s")
            }
        }
        workouts = tempArr
    }
    
    public func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pos = PositioningConstants.init()
        
        userNameLabel = UILabel(frame: CGRect(x: 0, y: pos.USERNAME_Y, width: pos.SCREEN_WIDTH, height: pos.USERNAME_HEIGHT))
        userNameLabel.textAlignment = .center
        userNameLabel.font = userNameLabel.font.withSize(40)
        userNameLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userNameLabel)
        
        
        // line above PB header
        let PBTopLine = UIBezierPath()
        PBTopLine.move(to: CGPoint(x: 0, y: pos.PB_HEADER_Y))
        PBTopLine.addLine(to: CGPoint(x: pos.SCREEN_WIDTH, y: pos.PB_HEADER_Y))
        let PBTopLineLayer = CAShapeLayer()
        PBTopLineLayer.path = PBTopLine.cgPath
        PBTopLineLayer.strokeColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        PBTopLineLayer.lineWidth = 1
        self.view.layer.addSublayer(PBTopLineLayer)
        
        // line below PBs header
        let PBBotLine = UIBezierPath()
        PBBotLine.move(to: CGPoint(x: 0, y: pos.TEN_Y + pos.PB_HEIGHTS))
        PBBotLine.addLine(to: CGPoint(x: pos.SCREEN_WIDTH, y: pos.TEN_Y + pos.PB_HEIGHTS))
        let PBBotLineLayer = CAShapeLayer()
        PBBotLineLayer.path = PBBotLine.cgPath
        PBBotLineLayer.strokeColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        PBBotLineLayer.lineWidth = 1
        self.view.layer.addSublayer(PBBotLineLayer)
        
        userPBHeaderLabel = UILabel(frame: CGRect(x: 5, y: pos.PB_HEADER_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEADER_HEIGHT))
        userPBHeaderLabel.textAlignment = .left
        userPBHeaderLabel.text = userPBHeaderLabelText
        userPBHeaderLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBHeaderLabel)
        
        userPBMaxHeaderLabel = UILabel(frame: CGRect(x: 12, y: pos.MAX_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBMaxHeaderLabel.textAlignment = .left
        userPBMaxHeaderLabel.text = userPBMaxHeaderLabelText
        userPBMaxHeaderLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBMaxHeaderLabel)
        
        userPBMaxLabel = UILabel(frame: CGRect(x: 0, y: pos.MAX_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBMaxLabel.textAlignment = .center
        userPBMaxLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBMaxLabel)
        
        userPBMaxNewRecordLabel = UILabel(frame: CGRect(x: 0, y: pos.MAX_Y, width: pos.SCREEN_WIDTH - 10, height: pos.PB_HEIGHTS))
        userPBMaxNewRecordLabel.textAlignment = .right
        userPBMaxNewRecordLabel.text = userPBNewRecordLabelText
        userPBMaxNewRecordLabel.textColor = #colorLiteral(red: 1, green: 0.2481553819, blue: 0.09906684028, alpha: 0.9145440925)
        userPBMaxNewRecordLabel.isHidden = true
        self.view.addSubview(userPBMaxNewRecordLabel)
        
        userPBThirtyHeaderLabel = UILabel(frame: CGRect(x: 12, y: pos.THIRTY_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBThirtyHeaderLabel.textAlignment = .left
        userPBThirtyHeaderLabel.text = userPBThirtyHeaderLabelText
        userPBThirtyHeaderLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBThirtyHeaderLabel)
        
        userPBThirtyLabel = UILabel(frame: CGRect(x: 0, y: pos.THIRTY_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBThirtyLabel.textAlignment = .center
        userPBThirtyLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBThirtyLabel)
        
        userPBThirtyNewRecordLabel = UILabel(frame: CGRect(x: 0, y: pos.THIRTY_Y, width: pos.SCREEN_WIDTH - 10, height: pos.PB_HEIGHTS))
        userPBThirtyNewRecordLabel.textAlignment = .right
        userPBThirtyNewRecordLabel.text = userPBNewRecordLabelText
        userPBThirtyNewRecordLabel.textColor = #colorLiteral(red: 1, green: 0.2481553819, blue: 0.09906684028, alpha: 0.9145440925)
        userPBThirtyNewRecordLabel.isHidden = true
        self.view.addSubview(userPBThirtyNewRecordLabel)
        
        userPBOneHeaderLabel = UILabel(frame: CGRect(x: 12, y: pos.ONE_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBOneHeaderLabel.textAlignment = .left
        userPBOneHeaderLabel.text = userPBOneHeaderLabelText
        userPBOneHeaderLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBOneHeaderLabel)
        
        userPBOneLabel = UILabel(frame: CGRect(x: 0, y: pos.ONE_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBOneLabel.textAlignment = .center
        userPBOneLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBOneLabel)
        
        userPBOneNewRecordLabel = UILabel(frame: CGRect(x: 0, y: pos.ONE_Y, width: pos.SCREEN_WIDTH - 10, height: pos.PB_HEIGHTS))
        userPBOneNewRecordLabel.textAlignment = .right
        userPBOneNewRecordLabel.text = userPBNewRecordLabelText
        userPBOneNewRecordLabel.textColor = #colorLiteral(red: 1, green: 0.2481553819, blue: 0.09906684028, alpha: 0.9145440925)
        userPBOneNewRecordLabel.isHidden = true
        self.view.addSubview(userPBOneNewRecordLabel)
        
        userPBTenHeaderLabel = UILabel(frame: CGRect(x: 12, y: pos.TEN_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBTenHeaderLabel.textAlignment = .left
        userPBTenHeaderLabel.text = userPBTenHeaderLabelText
        userPBTenHeaderLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBTenHeaderLabel)
        
        userPBTenLabel = UILabel(frame: CGRect(x: 0, y: pos.TEN_Y, width: pos.SCREEN_WIDTH, height: pos.PB_HEIGHTS))
        userPBTenLabel.textAlignment = .center
        userPBTenLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userPBTenLabel)
        
        userPBTenNewRecordLabel = UILabel(frame: CGRect(x: 0, y: pos.TEN_Y, width: pos.SCREEN_WIDTH - 10, height: pos.PB_HEIGHTS))
        userPBTenNewRecordLabel.textAlignment = .right
        userPBTenNewRecordLabel.text = userPBNewRecordLabelText
        userPBTenNewRecordLabel.textColor = #colorLiteral(red: 1, green: 0.2481553819, blue: 0.09906684028, alpha: 0.9145440925)
        userPBTenNewRecordLabel.isHidden = true
        self.view.addSubview(userPBTenNewRecordLabel)
        
        
        userWorkoutsHeaderLabel = UILabel(frame: CGRect(x: 0, y: pos.WORKOUTS_HEADER_Y, width: pos.SCREEN_WIDTH, height: pos.WORKOUTS_HEADER_HEIGHT))
        userWorkoutsHeaderLabel.textAlignment = .center
        userWorkoutsHeaderLabel.text = userWorkoutsHeaderLabelText
        userWorkoutsHeaderLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userWorkoutsHeaderLabel)
        
        userWorkoutsTableView = UITableView(frame: CGRect(x: 0, y: pos.WORKOUTS_Y, width: pos.SCREEN_WIDTH, height: pos.WORKOUTS_HEIGHT))
        userWorkoutsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        userWorkoutsTableView.dataSource = self
        userWorkoutsTableView.delegate = self
        userWorkoutsTableView.separatorColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        self.view.addSubview(userWorkoutsTableView)
    }
    
    //TABLE VIEW METHODS
    // on user select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selects \(workouts[indexPath.row])")
        workoutSelected = workouts[indexPath.row].split(separator: "|")[0].trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        self.performSegue(withIdentifier: "ViewWorkout", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(workouts[indexPath.row])"
        cell.textLabel!.textColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 1)
        return cell
    }
}
