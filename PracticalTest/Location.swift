//
//  Location.swift
//  PracticalTest
//
//  Created by Mittal Banker on 01/10/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation

public class Location {

    public var time : String
    public var lattitude : String
    public var longitude : String
    public var current_time_interval : String
    public var next_time_interval : String

    init?(time:String, lattitude:String, longitude:String, current_time_interval:String, next_time_interval:String  ) {
        self.time = time
        self.lattitude = lattitude
        self.longitude = longitude
        self.current_time_interval = current_time_interval
        self.next_time_interval = next_time_interval
    }

    
}
