//
//  ViewWorkoutViewController.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/22/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import UIKit
import Charts

struct ViewWorkoutPositioningConstants {
    let GRAPH_Y : Int
    let GRAPH_HEIGHT : Int
    let SCREEN_WIDTH : Int
    let VERT_STACK_Y : Int
    let VERT_STACK_HEIGHT : Int
    
    init() {
        GRAPH_Y = 0
        GRAPH_HEIGHT = (Int(UIScreen.main.bounds.height) - 64)/2
        SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
        VERT_STACK_Y = GRAPH_Y + GRAPH_HEIGHT
        VERT_STACK_HEIGHT = GRAPH_HEIGHT
    }
}


class ViewWorkoutViewController: UIViewController {
    
    // chart specific variables
    var chartView: LineChartView!
    var graphData = [ChartDataEntry]()
    
    // best label variables
    let bestTenMinLabel = UILabel()
    let bestOneMinLabel = UILabel()
    let bestThirtySecLabel = UILabel()
    let bestMaxLabel = UILabel()
    let totalTimeLabel = UILabel()
    let avgWattsLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pos = ViewWorkoutPositioningConstants.init()
        
        // Graph

        chartView = LineChartView(frame: CGRect(x: 0, y: pos.GRAPH_Y, width: pos.SCREEN_WIDTH, height: pos.GRAPH_HEIGHT))
        self.view.addSubview(chartView)
        
        
        // Summary data
        
        // Best max labels
        let bestMaxLabelHeader = UILabel()
        bestMaxLabelHeader.text = "Max Watts"
        bestMaxLabelHeader.font = bestMaxLabelHeader.font.withSize(23)
        bestMaxLabelHeader.textAlignment = .center
        bestMaxLabelHeader.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.8)
        bestMaxLabel.text = ""
        bestMaxLabel.font = bestMaxLabel.font.withSize(30)
        bestMaxLabel.textAlignment = .center
        bestMaxLabel.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.8)
        
        // Best thirty second labels
        let bestThirtySecLabelHeader = UILabel()
        bestThirtySecLabelHeader.text = "Best 30s Avg"
        bestThirtySecLabelHeader.font = bestThirtySecLabelHeader.font.withSize(23)
        bestThirtySecLabelHeader.textAlignment = .center
        bestThirtySecLabelHeader.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.6)
        bestThirtySecLabel.text = ""
        bestThirtySecLabel.font = bestThirtySecLabel.font.withSize(30)
        bestThirtySecLabel.textAlignment = .center
        bestThirtySecLabel.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.6)
        
        // Best one minute label
        let bestOneMinLabelHeader = UILabel()
        bestOneMinLabelHeader.text = "Best 1m Avg"
        bestOneMinLabelHeader.font = bestOneMinLabelHeader.font.withSize(23)
        bestOneMinLabelHeader.textAlignment = .center
        bestOneMinLabelHeader.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.6)
        bestOneMinLabel.text = ""
        bestOneMinLabel.font = bestOneMinLabel.font.withSize(30)
        bestOneMinLabel.textAlignment = .center
        bestOneMinLabel.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.6)
        
        // Best ten minute label
        let bestTenMinLabelHeader = UILabel()
        bestTenMinLabelHeader.text = "Best 10m Avg"
        bestTenMinLabelHeader.font = bestTenMinLabelHeader.font.withSize(23)
        bestTenMinLabelHeader.textAlignment = .center
        bestTenMinLabelHeader.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.8)
        bestTenMinLabel.text = ""
        bestTenMinLabel.font = bestTenMinLabel.font.withSize(30)
        bestTenMinLabel.textAlignment = .center
        bestTenMinLabel.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.8)
        
        // total time label
        let totalTimeLabelHeader = UILabel()
        totalTimeLabelHeader.text = "Total Time"
        totalTimeLabelHeader.font = bestTenMinLabelHeader.font.withSize(23)
        totalTimeLabelHeader.textAlignment = .center
        totalTimeLabelHeader.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.8)
        totalTimeLabel.text = ""
        totalTimeLabel.font = bestTenMinLabel.font.withSize(30)
        totalTimeLabel.textAlignment = .center
        totalTimeLabel.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.8)
        
        // avg watts label
        let avgWattsLabelHeader = UILabel()
        avgWattsLabelHeader.text = "Avg Watts"
        avgWattsLabelHeader.font = bestTenMinLabelHeader.font.withSize(23)
        avgWattsLabelHeader.textAlignment = .center
        avgWattsLabelHeader.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.6)
        avgWattsLabel.text = ""
        avgWattsLabel.font = bestTenMinLabel.font.withSize(30)
        avgWattsLabel.textAlignment = .center
        avgWattsLabel.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4823529412, blue: 0.662745098, alpha: 0.6)
        
        
        // nested stack Views
        let v1StackView = UIStackView()
        v1StackView.axis = UILayoutConstraintAxis.vertical
        v1StackView.distribution = .fillEqually
        v1StackView.alignment = UIStackViewAlignment.fill
        v1StackView.spacing = 0
        v1StackView.addArrangedSubview(bestMaxLabelHeader)
        v1StackView.addArrangedSubview(bestMaxLabel)
        
        let v2StackView = UIStackView()
        v2StackView.axis = UILayoutConstraintAxis.vertical
        v2StackView.distribution = .fillEqually
        v2StackView.alignment = UIStackViewAlignment.fill
        v2StackView.spacing = 0
        v2StackView.addArrangedSubview(bestThirtySecLabelHeader)
        v2StackView.addArrangedSubview(bestThirtySecLabel)
        
        let v3StackView = UIStackView()
        v3StackView.axis = UILayoutConstraintAxis.vertical
        v3StackView.distribution = .fillEqually
        v3StackView.alignment = UIStackViewAlignment.fill
        v3StackView.spacing = 0
        v3StackView.addArrangedSubview(bestOneMinLabelHeader)
        v3StackView.addArrangedSubview(bestOneMinLabel)
        
        let v4StackView = UIStackView()
        v4StackView.axis = UILayoutConstraintAxis.vertical
        v4StackView.distribution = .fillEqually
        v4StackView.alignment = UIStackViewAlignment.fill
        v4StackView.spacing = 0
        v4StackView.addArrangedSubview(bestTenMinLabelHeader)
        v4StackView.addArrangedSubview(bestTenMinLabel)
        
        let v5StackView = UIStackView()
        v5StackView.axis = UILayoutConstraintAxis.vertical
        v5StackView.distribution = .fillEqually
        v5StackView.alignment = UIStackViewAlignment.fill
        v5StackView.spacing = 0
        v5StackView.addArrangedSubview(totalTimeLabelHeader)
        v5StackView.addArrangedSubview(totalTimeLabel)
        
        let v6StackView = UIStackView()
        v6StackView.axis = UILayoutConstraintAxis.vertical
        v6StackView.distribution = .fillEqually
        v6StackView.alignment = UIStackViewAlignment.fill
        v6StackView.spacing = 0
        v6StackView.addArrangedSubview(avgWattsLabelHeader)
        v6StackView.addArrangedSubview(avgWattsLabel)
        
        let h1StackView = UIStackView()
        h1StackView.axis = UILayoutConstraintAxis.horizontal
        h1StackView.distribution = .fillEqually
        h1StackView.alignment = UIStackViewAlignment.fill
        h1StackView.spacing = 0
        h1StackView.addArrangedSubview(v1StackView)
        h1StackView.addArrangedSubview(v2StackView)
        
        let h2StackView = UIStackView()
        h2StackView.axis = UILayoutConstraintAxis.horizontal
        h2StackView.distribution = .fillEqually
        h2StackView.alignment = UIStackViewAlignment.fill
        h2StackView.spacing = 0
        h2StackView.addArrangedSubview(v3StackView)
        h2StackView.addArrangedSubview(v4StackView)
        
        let h3StackView = UIStackView()
        h3StackView.axis = UILayoutConstraintAxis.horizontal
        h3StackView.distribution = .fillEqually
        h3StackView.alignment = UIStackViewAlignment.fill
        h3StackView.spacing = 0
        h3StackView.addArrangedSubview(v5StackView)
        h3StackView.addArrangedSubview(v6StackView)
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: pos.VERT_STACK_Y, width: pos.SCREEN_WIDTH, height: pos.VERT_STACK_HEIGHT))
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = .fillEqually
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing = 0
        stackView.addArrangedSubview(h1StackView)
        stackView.addArrangedSubview(h2StackView)
        stackView.addArrangedSubview(h3StackView)
        self.view.addSubview(stackView)
        
        
        // Create navbar header
        let titleLabel = UILabel()
        titleLabel.text = workoutSelected
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.sizeToFit()
        let rightItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.rightBarButtonItem = rightItem
        
        // get Data
        DatabaseMethods.getUserData(key: docKey) {
            data in
            self.populateGraph(data: data);
            self.populateBests(data: data);
        }
    }
    
    func populateGraph(data : [String : Any]) {
        let workoutKey = "workout\(workoutSelected.split(separator: " ")[1].suffix(1))"
        if (data[workoutKey] as! NSDictionary)["wattdata"] != nil {
            let dbData = ((data[workoutKey] as! NSDictionary)["wattdata"] as! [NSDictionary])
            for entry in dbData {
                graphData.append(ChartDataEntry(x:Double(entry["time"] as! NSNumber), y:Double(entry["data"] as! NSNumber)))
            }
            let line1 = LineChartDataSet(values: graphData, label: "Watts")
            line1.drawCirclesEnabled = false
            line1.drawValuesEnabled = false
            line1.colors = [UIColor(red: 17/255, green: 123/255, blue: 169/255, alpha: 1)]
            let data = LineChartData()
            data.addDataSet(line1)
            chartView.data = data
            chartView.chartDescription?.enabled = false
            chartView.rightAxis.enabled = false
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.leftAxis.drawGridLinesEnabled = false
            chartView.xAxis.labelPosition = .bottom
            chartView.legend.enabled = false
        }
    }
    
    func populateBests(data : [String : Any]) {
        let workoutKey = "workout\(workoutSelected.split(separator: " ")[1].suffix(1))"
        bestTenMinLabel.text = "\(((data[workoutKey] as! NSDictionary)["bests"] as! NSDictionary)["ten"] as! NSNumber)"
        bestOneMinLabel.text = "\(((data[workoutKey] as! NSDictionary)["bests"] as! NSDictionary)["one"] as! NSNumber)"
        bestThirtySecLabel.text = "\(((data[workoutKey] as! NSDictionary)["bests"] as! NSDictionary)["thirty"] as! NSNumber)"
        bestMaxLabel.text = "\(((data[workoutKey] as! NSDictionary)["bests"] as! NSDictionary)["max"] as! NSNumber)"
        
        let time = ((((data[workoutKey] as! NSDictionary)["wattdata"] as! [[String : NSNumber]]).last as! [String: NSNumber])["time"] as! NSNumber)
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(time))
        totalTimeLabel.text = "\(h)h \(m)m \(s)s"
        
        let wd = (data[workoutKey] as! NSDictionary)["wattdata"] as! [[String : NSNumber]]
        var totalWatts = 0
        for item in wd {
            totalWatts += item["data"] as! Int
        }
        let avgWatts = Int(totalWatts / wd.count)
        avgWattsLabel.text = "\(avgWatts)"
    }
    
    public func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}
