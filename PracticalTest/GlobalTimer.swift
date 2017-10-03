//
//  GlobalTimer.swift
//  PracticalTest
//
//  Created by Mittal Banker on 01/10/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
class GlobalTimer: NSObject {

    static let sharedTimer: GlobalTimer = {
        let timer = GlobalTimer()
        return timer
    }()

    var internalTimer: Timer?

    func startTimer(){
        self.internalTimer?.invalidate()
        
        self.internalTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1) /*seconds*/, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
    }

    func stopTimer(){

        self.internalTimer?.invalidate()
        PTLocationSingleton.sharedInstance.startUpdatingLocation()

    }

    /* check the date and call update location according to it*/
    func fireTimerAction(sender: AnyObject?){
        if(AppDelegate.shared().vehicleStarted==false){
        AppDelegate.shared().vehicleStarted = true
        PTLocationSingleton.sharedInstance.updateLocation()
        AppDelegate.shared().current_date = Date()
        } else {
            let nowDate = Date()
            let newDate = AppDelegate.shared().current_date?.addingTimeInterval(TimeInterval(AppDelegate.shared().next_time_interval))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date1 = dateFormatter.date(from: dateFormatter.string(from: nowDate))!
            let date2 = dateFormatter.date(from: dateFormatter.string(from: newDate!))!

            if(Constants.DEBUG_MODE){
                print(date1)
                print(date2)
            }
            if(date1==date2){
                PTLocationSingleton.sharedInstance.updateLocation()
                AppDelegate.shared().current_date = Date()

            }
        }
        
    }
    
}
