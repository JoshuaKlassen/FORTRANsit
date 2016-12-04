//
//  DataService.swift
//  FORTRANsit
//
//  Created by Josh Klassen on 2016-12-03.
//  Copyright © 2016 Josh Klassen. All rights reserved.
//

import Foundation

open class DataService{
    
    //apiKey
    static var apiKey = "FTy2QN8ts293ZlhYP1t";
    
    //url to the api
    static var url = "https://api.winnipegtransit.com/v2/";
    
    //call this to get the current time of the system in hh:mm (h=hour, m=minutes)
    open class func getTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        var hourString = "\(hour)"
        var minuteString = "\(minutes)"
        
        if(minutes <= 9){
            minuteString = "0\(minutes)"
        }
        if(hour < 9){
            hourString = "0\(hour)"
        }
        
        return "\(hourString):\(minuteString)"
    }
    
    //call this to convert a datetime to a time in 12 hour hh:mm format (h=hour, m=minute)
    open class func formatTime(time: String) -> String{
        let index = time.index(time.startIndex, offsetBy: 11)
        
        var timeString = time.substring(from: index)
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.default
        formatter.dateFormat = "k:mm:ss"
        let date = formatter.date(from: timeString)
        
        if(date != nil){
            formatter.dateFormat = "h:mm a"
            let dateString = formatter.string(from: date as Date!)
            timeString = dateString
            
        }
        
        return timeString
    }
    
    //call this to send a request
    //will call the given completionHandler function given
    open class func sendRequest(request: String, completionHandler: @escaping (AnyObject)->()){
        let requestURL: NSURL = NSURL(string: (url + request + "api-key=" + apiKey))!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    
                    let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                    
                    completionHandler(json!)
                    
                }
            }
        }
        
        task.resume();
    }
}
