//
//  LocationManager.swift
//  PracticalTest
//
//  Created by Mittal Banker on 30/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import CoreLocation

enum INTERVAL_TYPE: Int {

    case SPEED_DECREASE = 1
    case SPEED_SAME_GRADUALLY = 2

}

protocol PTLocationServiceDelegate {
    func tracingLocation(currentLocation: Location,speed:CLLocationSpeed)
    func tracingLocationDidFailWithError(error: NSError)
}

class PTLocationSingleton: NSObject,CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: PTLocationServiceDelegate?
    var lastSpeed = 0.0
    var currentSpeed = 0.0
    var nexTimeteval = 300
    var currentTimeInteval = 0
    var suddenSpeedLow = false
    var currentLocation:CLLocation!
    static let sharedInstance:PTLocationSingleton = {
        let instance = PTLocationSingleton()
        return instance
    }()

    override init() {
        super.init()
        self.locationManager = CLLocationManager()

        guard let locationManagers=self.locationManager else {
            return
        }

        /* check authorization status*/
        _ = self.checkAuthorizationStatus()

        if #available(iOS 9.0, *) {
            //            locationManagers.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        locationManagers.desiredAccuracy = kCLLocationAccuracyBest
        locationManagers.pausesLocationUpdatesAutomatically = false
        locationManagers.distanceFilter = kCLDistanceFilterNone
        locationManagers.delegate = self

    }

    //MARK: LOCATION MANAGER EVENTS
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }

        self.lastLocation = location
        var speed = (self.lastLocation?.speed)!
        if (speed > 0) {
            if(Constants.DEBUG_MODE){
            print(speed) // or whatever
            }
        } else {

            /* when you travel long speed will get*/
            speed = location.distance(from: self.lastLocation!) / (self.lastLocation?.timestamp.timeIntervalSince(location.timestamp))!
            if(Constants.DEBUG_MODE){
            print(speed)
            }

        }
        currentLocation = location

        if(speed.isNaN){
            return
        }
        currentSpeed = Double(speed)
        if(currentSpeed>0){
            self.setTimeIntervalAcordingToSpeed()
        }

        lastSpeed = Double(speed)

        AppDelegate.shared().current_time_interval = nexTimeteval
    }


    @nonobjc func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }

    //MARK: CUSTOM EVENTS
    func checkAuthorizationStatus()->Bool{
        /* check for authorization status of the location*/
        var locationOn = false
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                self.locationManager?.requestAlwaysAuthorization()
                self.locationManager?.requestWhenInUseAuthorization()
            case .restricted, .denied:
                if(Constants.DEBUG_MODE){
                print("No access")
                }

            case .authorizedAlways, .authorizedWhenInUse:
                locationOn = true
                print("Access")
            }
        }
        else{
            //You could show an alert like this.
            locationOn = false
            let alertController = UIAlertController(title: "location_access_title".localized, message: "location_access_message".localized, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default,
                                         handler: nil)
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                AppDelegate.shared().window?.rootViewController?.present(alertController, animated: true,
                                                                         completion:nil)
            }
        }
        return locationOn
    }
    // Private function
    func updateLocation(){


        guard let delegate = self.delegate else {
            return
        }
        if((currentLocation) != nil){
        let coord = currentLocation.coordinate
        let longitude = coord.longitude //Latitude & Longitude as String
        let latitude = coord.latitude
        let loc:Location = Location (time: Utils.getTodayDate(date: Date()),lattitude:String(latitude),longitude:String(longitude),current_time_interval:String(currentTimeInteval),next_time_interval:String(nexTimeteval))!
        delegate.tracingLocation(currentLocation: loc, speed: CLLocationSpeed(currentSpeed))
        }

    }

    private func updateLocationDidFailWithError(error: NSError) {

        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidFailWithError(error: error)

    }

    func startUpdatingLocation() {
        if(Constants.DEBUG_MODE){
        print("Starting Location Updates")
        }
        self.locationManager?.startUpdatingLocation()
        self.locationManager?.startMonitoringSignificantLocationChanges()
        GlobalTimer.sharedTimer.startTimer()
        //self.locationManager?.stopUpdatingLocation()
    }

    func stopUpdatingLocation() {
        if(Constants.DEBUG_MODE){
        print("Stop Location Updates")
        }
        self.locationManager?.stopUpdatingLocation()
        GlobalTimer.sharedTimer.stopTimer()
    }

    func startMonitoringSignificantLocationChanges() {
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }

    /* set time Interval*/
    func setTimeIntervalAcordingToSpeed(){
        if(currentSpeed==lastSpeed){
            if(suddenSpeedLow==true){
                currentTimeInteval = nexTimeteval
                nexTimeteval = self.getNextTimeInterval(intervalType: INTERVAL_TYPE.SPEED_SAME_GRADUALLY)
            } else {
                setTimeInterval()
            }
        }
        else if(currentSpeed>lastSpeed){
            suddenSpeedLow = false
            setTimeInterval()
        } else {
            suddenSpeedLow = true
            currentTimeInteval = nexTimeteval
            nexTimeteval = self.getNextTimeInterval(intervalType: INTERVAL_TYPE.SPEED_DECREASE)
        }
    }

    func setTimeInterval(){
        var timeInterval = 0
        //        // to check speed and set time interval
        if(currentSpeed==0){
            currentTimeInteval = 0
            nexTimeteval = 300
        } else {
            switch currentSpeed {
            case  0...30:
                timeInterval = 300
            case  31...60:
                timeInterval = 120
            case  61...80:
                timeInterval = 60
            default:
                timeInterval = 30
                currentTimeInteval = nexTimeteval
                nexTimeteval = timeInterval
            }
        }

    }
    func getNextTimeInterval(intervalType:INTERVAL_TYPE)->Int{
        var timeInterval = 0
        if(intervalType==INTERVAL_TYPE.SPEED_DECREASE){
            switch lastSpeed {
            case  0...30:
                timeInterval = 300
            case  31...60:
                timeInterval = 300
            case  61...80:
                timeInterval = 120
            default:
                timeInterval = 60
            }
            return timeInterval
        } else {
            switch currentTimeInteval {
            case  300:
                timeInterval = 300
            case  60:
                timeInterval = 120
            case  120:
                timeInterval = 300
            default:
                timeInterval = 60
            }
            return timeInterval
        }
    }
    // #MARK:   get the alarm time from date and time
}
