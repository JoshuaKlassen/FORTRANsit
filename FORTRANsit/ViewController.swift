//
//  ViewController.swift
//  FORTRANsit
//
//  Created by Josh Klassen on 2016-12-03.
//  Copyright © 2016 Josh Klassen. All rights reserved.
//

import UIKit
import Foundation

import FORTRANsitFramework

class ViewController: UIViewController {

    var currentInfo: AnyObject?;
    
    var urlParamType = "stops/";
    
    var origin = "addresses/22458";
    var dest = "addresses/191997";
    var time = "09:00";
    var urlParams = "";
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var busList: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        button.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        
    }
    
    func handlerUpdate(data: AnyObject){
      //  print("Data: \(data as! NSDictionary)")
        var json = data as! NSDictionary
        
        print(json)
       // print(json["plans"])
        
        var resultText = ""
        print("Processing app")
        if let trips = json["plans"] as? [[String: AnyObject]]{
            for trip in trips{
                var times = trip["times"]
                var start = times?["start"] as! String
                var end = times?["end"] as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                
                let startIndex = start.index(start.startIndex, offsetBy: 11)
                let endIndex = end.index(end.startIndex, offsetBy: 11)
                
                let startTime = start.substring(from: startIndex)
                let endTime = end.substring(from: endIndex)
                
                print("Trip:")
                print("Start: \(startTime)")
                print("End: \(endTime)")
                print("")
                
                resultText += "Trip: Start: \(startTime)End: \(endTime)"
            }
        }
        
        DispatchQueue.main.sync(execute: {
            label.text = "Data: \(data)"
            busList.text = resultText
        })
    }
    
    func buttonAction(sender: UIButton){
        var tempUrl = "stops/10064/schedule.json?";
        time = DataService.getTime()
        print(time)
        tempUrl = "trip-planner.json?origin=\(origin)&destination=\(dest)&time=\(time)&mode=depart-after&";
        print(tempUrl)
        DataService.sendRequest(request: tempUrl, completionHandler: handlerUpdate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

