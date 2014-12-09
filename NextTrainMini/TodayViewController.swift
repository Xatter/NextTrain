//
//  TodayViewController.swift
//  NextTrainMini
//
//  Created by Josh Wais on 12/7/14.
//  Copyright (c) 2014 Josh Wais. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var timeNYP: UILabel!
    @IBOutlet weak var trackNYP: UILabel!
    @IBOutlet weak var timeBay: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTimes()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func refreshTimes() {
        let urlNYP = "http://api.import.io/store/data/6e303761-1264-4c2d-9177-cbf3d0d06b02/_query?input/webpage/url=http%3A%2F%2Fdv.njtransit.com%2Fmobile%2Ftid-mobile.aspx%3Fsid%3DNY&_user=fccbaad2-ea64-485c-8bf2-877d4b568793&_apikey=qwLbJuckegDiayXTdpDKjolj22py34SnxlFhjiVczPJYC5RQKIp9c%2B4uJPBXL5Dk1nJsG6QHutkb3%2FnQVB5ttA%3D%3D"
        let feedNYP: NSURL = NSURL(string: urlNYP)!
        let sessionNYP = NSURLSession.sharedSession()
        let taskNYP = sessionNYP.dataTaskWithURL(feedNYP, completionHandler: {dataNYP, response, error -> Void in
            if (error != nil) {
                println(error)
            }
            let jsonResultNYP = NSJSONSerialization.JSONObjectWithData(dataNYP, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSMutableDictionary
            let jsonNYP = JSON(data: dataNYP)
            for var i = 1; i < 10 && self.timeNYP.text == ""; {
                if jsonNYP["results"][i]["text_2"].stringValue == "MSU -SEC" {
                    dispatch_async(dispatch_get_main_queue()){
                        self.timeNYP.text = jsonNYP["results"][i]["text_1"].stringValue
                        self.trackNYP.text = jsonNYP["results"][i]["text_3"].stringValue
                    }
                }
                else {++i}
            }
        })
        taskNYP.resume()
        
        
        let urlBay = "http://api.import.io/store/data/7223ff00-1da2-42f6-8fef-ee7c4804e13c/_query?input/webpage/url=http%3A%2F%2Fdv.njtransit.com%2Fmobile%2Ftid-mobile.aspx%3Fsid%3DMC&_user=fccbaad2-ea64-485c-8bf2-877d4b568793&_apikey=qwLbJuckegDiayXTdpDKjolj22py34SnxlFhjiVczPJYC5RQKIp9c%2B4uJPBXL5Dk1nJsG6QHutkb3%2FnQVB5ttA%3D%3D"
        let feedBay: NSURL = NSURL(string: urlBay)!
        let sessionBay = NSURLSession.sharedSession()
        let taskBay = sessionBay.dataTaskWithURL(feedBay, completionHandler: {dataBay, response, error -> Void in
            if (error != nil) {
                println(error)
            }
            let jsonResultBay = NSJSONSerialization.JSONObjectWithData(dataBay, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSMutableDictionary
            let jsonBay = JSON(data: dataBay)
            for var n = 1; n < 10 && self.timeBay.text == ""; {
                if jsonBay["results"][n]["text_2"].stringValue == "NY Penn -SEC" {
                    dispatch_async(dispatch_get_main_queue()){
                        self.timeBay.text = jsonBay["results"][n]["text_1"].stringValue
                    }
                }
                else {++n}
            }
            
            
        })
        taskBay.resume()
    }
    
}
