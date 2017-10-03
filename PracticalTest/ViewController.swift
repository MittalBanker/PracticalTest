//
//  ViewController.swift
//  PracticalTest
//
//  Created by Mittal Banker on 30/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, PTLocationServiceDelegate {

    //initialize button controls
    @IBOutlet weak var btnLocationOnOff: UIButton!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblSpeedDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        PTLocationSingleton.sharedInstance.delegate = self
        AppDelegate.shared().vehicleStarted = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let value = UserDefaults.standard.value(forKey: "locationUpdate") as? Bool, value == false {
            btnLocationOnOff.isSelected = false
        } else {
            if(PTLocationSingleton.sharedInstance.checkAuthorizationStatus()==true){
                PTLocationSingleton.sharedInstance.startUpdatingLocation()
            }
            btnLocationOnOff.isSelected = true
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func locationUpdateOnOffClick(sender:AnyObject? = nil){
        /* to start or stop location updates on button click */
        btnLocationOnOff.isSelected = !(sender as AnyObject).isSelected
        if let value = UserDefaults.standard.value(forKey: "locationUpdate") as? Bool, value == false {
            PTLocationSingleton.sharedInstance.stopUpdatingLocation()

        }
        else
        {
            if(PTLocationSingleton.sharedInstance.checkAuthorizationStatus()==true){
            PTLocationSingleton.sharedInstance.startUpdatingLocation()
            }
            // error does not exist/ false.
        }
    UserDefaults.standard.set(btnLocationOnOff.isSelected                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   , forKey: "locationUpdate")
        UserDefaults.standard.synchronize()
        
    }

    func tracingLocation(currentLocation: Location,speed:CLLocationSpeed){
        lblSpeed.text = String(speed)

        let stringToWrite = currentLocation.time + currentLocation.lattitude + currentLocation.longitude + currentLocation.current_time_interval + currentLocation.next_time_interval
        Utils.write(text: stringToWrite, to: "location", folder: "SavedLocation")

        DBManager.shared.insertLocationData(location: currentLocation)
    }

    func tracingLocationDidFailWithError(error: NSError)
    {
        
    }
    
}

