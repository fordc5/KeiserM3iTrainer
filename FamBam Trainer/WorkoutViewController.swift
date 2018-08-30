//
//  WorkoutViewController.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/17/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import UIKit
import Charts
import CoreBluetooth
import Firebase

class WorkoutViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var chartView = LineChartView()
    let data = LineChartData()
    
    let startStopButtons = UIStackView()
    let stopButton = UIButton()
    let startButton = UIButton()
    let resumeButton = UIButton()
    let finishButton = UIButton()
    
    var packetCaptureOn = false
    
    var docName = ""
    
    let wattLabel = UILabel()
    
    var centralManager: CBCentralManager!
    var bikeDataPeripheral: CBPeripheral?
    
    var startTime : Double = 0.0
    
    var cumulativePause : Double = 0.0
    var startPause : Double!
    
    var dataArray = [WattTimeObject]()
    
    var workoutNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Workout view loading")
        
        // Create a navView to add to the navigation bar
        let navView = UIView()
        // Create the label
        let label = UILabel()
        label.text = "\(workoutUser) Workout"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        // Add both the label and image view to the navView
        navView.addSubview(label)
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        self.navigationItem.hidesBackButton = true
        
        // VIEWS:
        
        chartView.data = data
        chartView.chartDescription?.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = true
        
        
        wattLabel.text = "---"
        wattLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        wattLabel.font = UIFont.systemFont(ofSize: 50)
        wattLabel.sizeToFit()
        wattLabel.center = navView.center
        wattLabel.textAlignment = NSTextAlignment.center
        
    
        startButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        startButton.layer.borderWidth = 3.0
        startButton.layer.cornerRadius = 10
        startButton.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1), for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        
        
        stopButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        stopButton.layer.borderWidth = 3.0
        stopButton.layer.cornerRadius = 10
        stopButton.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1), for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        stopButton.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
        stopButton.isHidden = true
        
        resumeButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        resumeButton.layer.borderWidth = 3.0
        resumeButton.layer.cornerRadius = 10
        resumeButton.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        resumeButton.setTitle("Resume", for: .normal)
        resumeButton.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1), for: .normal)
        resumeButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        resumeButton.addTarget(self, action: #selector(resumeButtonAction), for: .touchUpInside)
        resumeButton.isHidden = true
        
        finishButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        finishButton.layer.borderWidth = 3.0
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1), for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        finishButton.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        finishButton.isHidden = true
        
        startStopButtons.axis = UILayoutConstraintAxis.horizontal
        startStopButtons.distribution = .fillEqually
        startStopButtons.alignment = UIStackViewAlignment.fill
        startStopButtons.spacing = 20
        startStopButtons.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        startStopButtons.isLayoutMarginsRelativeArrangement = true
        startStopButtons.addArrangedSubview(startButton)
        startStopButtons.addArrangedSubview(stopButton)
        startStopButtons.addArrangedSubview(resumeButton)
        startStopButtons.addArrangedSubview(finishButton)
        
        let v1StackView = UIStackView()
        v1StackView.axis = UILayoutConstraintAxis.vertical
        v1StackView.distribution = .fillEqually
        v1StackView.alignment = UIStackViewAlignment.fill
        v1StackView.spacing = 0
        v1StackView.addArrangedSubview(wattLabel)
        v1StackView.addArrangedSubview(startStopButtons)
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = .fillEqually
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing = 0
        stackView.addArrangedSubview(chartView)
        stackView.addArrangedSubview(v1StackView)
        self.view.addSubview(stackView)
        
        
        // bt initialization
        centralManager = CBCentralManager(delegate: self, queue: nil)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        // turn off sleep for this view
        UIApplication.shared.isIdleTimerDisabled = true
        
        print("Data view loading for user: \(workoutUser)")
        
        // get user data
        let userName = workoutUser
        let first = String(userName.split(separator: " ")[0])
        let last = String(userName.split(separator: " ")[1])
        let docKey = "\(first)\(last)".lowercased()
        
        DatabaseMethods.getUserData(key: docKey) {
            data in
            self.setWorkoutNumber(data: data);
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //turn back on sleep
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func setWorkoutNumber(data: [String : Any]) {
        var tempArr = [Int]()
        tempArr.append(0)
        let keys = data.keys
        for key in keys {
            if (key).contains("workout") {
                let workoutNum = key.dropFirst(7)
                tempArr.append(Int(workoutNum)!)
            }
        }
        workoutNumber = tempArr.max()! + 1
    }
    
    
    // start button listener
    @objc func startButtonAction(sender: UIButton!) {
        print("Start Workout")
        startButton.isHidden = true
        stopButton.isHidden = false
        
        // start capturing packets
        packetCaptureOn = true
        
        // using current date and time as an example
        let startDate = Date()
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = startDate.timeIntervalSince1970
        // convert to Integer
        startTime = Double(timeInterval)
        
        //initialize space in db for workout
        docName = workoutUser.split(separator: " ")[0].lowercased() + workoutUser.split(separator: " ")[1].lowercased()
        
       
        db.collection("users").document(docName).setData(["workout\(workoutNumber)": ["Timestamp": Timestamp(date: Date())]], merge:true)
    }
    
    // stop button listener
    @objc func stopButtonAction(sender: UIButton!) {
        print("Stop Workout")
        stopButton.isHidden = true
        resumeButton.isHidden = false
        finishButton.isHidden = false
        
        // stop packet capture
        packetCaptureOn = false
        wattLabel.text = "---"
        
        let startPauseDate = Date()
        let startPauseTimeInterval = startPauseDate.timeIntervalSince1970
        startPause = Double(startPauseTimeInterval)
    }
    
    // resume button listener
    @objc func resumeButtonAction(sender: UIButton!) {
        print("Resume Workout")
        resumeButton.isHidden = true
        finishButton.isHidden = true
        stopButton.isHidden = false
        
        // start packet capture
        packetCaptureOn = true
        let resumeDate = Date()
        let resumeTimeInterval = resumeDate.timeIntervalSince1970
        cumulativePause = cumulativePause + (Double(resumeTimeInterval) - startPause)
    }
    
    // finish button listener
    @objc func finishButtonAction(sender: UIButton!) {
        print("Finish Workout")
        
        // stop packet capture
        packetCaptureOn = false
        
        //analysis and database ingestion
        var wattdata = [[String : NSNumber]]()
        for stamp in dataArray {
            wattdata.append(["data": NSNumber(value: stamp.getWatts()), "time": NSNumber(value: stamp.getOffset())])
        }
        
        let max : Int = findMax()
        let one : Int = Int(round(findOther(val : 60)))
        let ten : Int = Int(round(findOther(val : 600)))
        let thirty : Int = Int(round(findOther(val : 30)))
        
        print("ride bests:")
        print(max)
        print(one)
        print(ten)
        print(thirty)
        
        db.collection("users").document(docName).setData(["workout\(workoutNumber)": ["bests": ["max":max, "one":one, "ten":ten, "thirty":thirty], "wattdata": wattdata]], merge:true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                // update/create PBs
                // make db call and then reset in callback function
                DatabaseMethods.getUserData(key: self.docName) {
                    data in
                    self.updatePBs(data: data, workoutMax: max, workoutOne: one, workoutTen: ten, workoutThirty: thirty);
                    self.moveToHome();
                }
            }
        }

        
        

    }
    
    func updatePBs(data: [String : Any], workoutMax: Int, workoutOne: Int, workoutTen: Int, workoutThirty: Int) {
        var oldMax = 0
        var oldTenMin = 0
        var oldOneMin = 0
        var oldThirtySec = 0
        var oldMaxWorkout = ""
        var oldTenWorkout = ""
        var oldOneWorkout = ""
        var oldThirtyWorkout = ""
        if data["PBs"] != nil {
            let PBs : NSDictionary = data["PBs"] as! NSDictionary
            oldMax = (PBs["Max"] as! NSDictionary)["watts"] as! Int
            oldMaxWorkout = (PBs["Max"] as! NSDictionary)["workout"] as! String
            oldTenMin = (PBs["10Minute"] as! NSDictionary)["watts"] as! Int
            oldTenWorkout = (PBs["10Minute"] as! NSDictionary)["workout"] as! String
            oldOneMin = (PBs["1Minute"] as! NSDictionary)["watts"] as! Int
            oldOneWorkout = (PBs["1Minute"] as! NSDictionary)["workout"] as! String
            oldThirtySec = (PBs["30Second"] as! NSDictionary)["watts"] as! Int
            oldThirtyWorkout = (PBs["30Second"] as! NSDictionary)["workout"] as! String
            
        }
        if workoutMax > oldMax {
            oldMax = workoutMax
            oldMaxWorkout = "workout\(workoutNumber)"
        }
        if workoutOne > oldOneMin {
            oldOneMin = workoutOne
            oldOneWorkout = "workout\(workoutNumber)"
        }
        if workoutTen > oldTenMin {
            oldTenMin = workoutTen
            oldTenWorkout = "workout\(workoutNumber)"
        }
        if workoutThirty > oldThirtySec {
            oldThirtySec = workoutThirty
            oldThirtyWorkout = "workout\(workoutNumber)"
        }
        db.collection("users").document(docName).setData(["PBs": ["10Minute": ["watts": oldTenMin, "workout": oldTenWorkout],                                                                                     "1Minute": ["watts": oldOneMin, "workout": oldOneWorkout], "30Second": ["watts": oldThirtySec, "workout": oldThirtyWorkout], "Max": ["watts": oldMax, "workout": oldMaxWorkout]]], merge: true)
    }
    
    func moveToHome() {
        self.performSegue(withIdentifier: "FinishWorkout", sender: self)
    }
    
    func findMax() -> Int {
        var max = 0
        for entry in dataArray {
            if entry.getWatts() > max {
                max = entry.getWatts()
            }
        }
        return max
    }
    
    func findOther(val : Double) -> Double {
        var max = 0.0
        var first = 0
        let lastTime = dataArray.last?.getOffset()
        while dataArray[first].getOffset() + val < lastTime! {
            var index = first
            while dataArray[index].getOffset() < dataArray[first].getOffset() + val {
                index += 1
            }
            var sum = 0
            for i in first...index {
                sum += dataArray[i].getWatts()
            }
            let avg = Double(sum) / (dataArray[index].getOffset() - dataArray[first].getOffset())
            if avg > max {
                max = avg
            }
            first += 1
        }
        return max
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if packetCaptureOn {
            if peripheral.name == "M3" {
                print(peripheral)
                print(advertisementData)
                let dataParser : MSBLEMachineBroadcast = MSBLEMachineBroadcast(manufactureData: advertisementData["kCBAdvDataManufacturerData"] as! Data)
                var power = 0
                if dataParser.dataType! < 1 || (dataParser.dataType! > 127 && dataParser.dataType! < 128) {
                    power = dataParser.power!
                } else {
                    power = 0
                }
                wattLabel.text = "\(power)"
                let packetDate = Date()
                let packetTimeInterval = packetDate.timeIntervalSince1970
                let packetTime = Double(packetTimeInterval)
                let packetTimeOffset = packetTime - startTime - cumulativePause
                print("point: \(power) watts and \(packetTimeOffset) time")
                let dataObject = WattTimeObject(watts: power, offset: packetTimeOffset)
                dataArray.append(dataObject)
                let d = chartView.data
                var set1 = d?.getDataSetByIndex(0)
                if (set1 == nil) {
                    set1 = createSet()
                    d?.addDataSet(set1)
                }
                d?.addEntry(ChartDataEntry(x:dataObject.getOffset(), y:Double(dataObject.getWatts())), dataSetIndex: 0)
                chartView.notifyDataSetChanged()
            }
        }
    }
    
    private func createSet() -> LineChartDataSet {
        let set : LineChartDataSet = LineChartDataSet(values: nil, label: "Watts");
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.colors = [#colorLiteral(red: 0.831372549, green: 0.6588235294, blue: 0.1450980392, alpha: 1)]
        return set;
    }
    

    
}
