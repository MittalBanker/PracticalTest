//
//  String+Extra.swift
//  PracticalTest
//
//  Created by Mittal Banker on 30/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var stringValue:String {
            return "\(self)"
    }  
}
