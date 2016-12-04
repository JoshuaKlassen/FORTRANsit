//
//  TodayViewController.swift
//  FORTRANsitWidget
//
//  Created by Josh Klassen on 2016-12-03.
//  Copyright © 2016 Josh Klassen. All rights reserved.
//

import UIKit
import NotificationCenter

import FORTRANsitFramework

class TodayViewController: UIViewController, NCWidgetProviding {
    
    //MARK: Properties
    var dest = "addresses/22458";
    var origin = "addresses/191997";
    var time = "09:00";
    var urlParams = "";
    
    struct RouteInfo{
        var busNumber: Int
        var departTime: String
    }
    
    var routeIndex = 0
    var routeInfoArray: [RouteInfo] = []

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextBusLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentRouteIndexLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: UIControlEvents.touchUpInside)
       
        let tempUrl = "trip-planner.json?origin=\(origin)&destination=\(dest)&time=\(DataService.getTime())&mode=depart-after&";
        
        DataService.sendRequest(request: tempUrl, completionHandler: updateHandler)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextButtonAction(){
        routeIndex += 1
        
        if(routeIndex >= routeInfoArray.count){
            routeIndex = 0
        }
        
        updateUI()
        
        //NSLog("Index: \(routeIndex)")
    }
    
    func updateUI(){
        if(routeInfoArray.count > 0){
            nextBusLabel.text = "Next Bus: \(routeInfoArray[routeIndex].busNumber)"
            label.text = "Departs: \(routeInfoArray[routeIndex].departTime)"
            currentRouteIndexLabel.text = "\(routeIndex+1) \\ \(routeInfoArray.count)"
        }
    }
    
    func updateHandler(data: AnyObject){
        let json = data as! NSDictionary

        var startText = "NA";
        
        var busNumber = 0;
        
        routeInfoArray.removeAll()
        
        DispatchQueue.main.sync(execute: {
            if let trips = json["plans"] as? [[String: AnyObject]]{
                for trip in trips{
                    let times = trip["times"]
                    let start = times?["start"] as! String
                    //let end = times?["end"] as! String
                    
                    startText = DataService.formatTime(time: start)
                    //endText = DataService.formatTime(time: end)
                        
                    if let segments = trip["segments"] as? [[String: AnyObject]]{
                        for segment in segments{
                            let type = segment["type"] as? String
                                
                            if(type == "ride"){
                                let route = segment["route"]
                                let number = route?["number"] as! Int
                                busNumber = number;
                                NSLog("\(number)")
                                break;
                            }
                        }
                    }
                    let route = RouteInfo(busNumber: busNumber, departTime: startText)
                    routeInfoArray.append(route)
                }
            }
            updateUI()
        })
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
