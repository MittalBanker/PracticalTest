//
//  PracticalTestTests.swift
//  PracticalTestTests
//
//  Created by Mittal Banker on 30/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest
@testable import PracticalTest

class PracticalTestTests: XCTestCase {
    var viewController = ViewController()
    override func setUp() {
        super.setUp()
        testInterval()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLocationCheck() {
        viewController.locationUpdateOnOffClick(sender: viewController.btnLocationOnOff)
    }

    func testInterval() {
        PTLocationSingleton.sharedInstance.nexTimeteval = 30
        PTLocationSingleton.sharedInstance.lastSpeed = 90
        PTLocationSingleton.sharedInstance.currentSpeed = 30
        PTLocationSingleton.sharedInstance.suddenSpeedLow = true
        PTLocationSingleton.sharedInstance.setTimeIntervalAcordingToSpeed()
        XCTAssertEqual(String(PTLocationSingleton.sharedInstance.nexTimeteval), "60")

    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
