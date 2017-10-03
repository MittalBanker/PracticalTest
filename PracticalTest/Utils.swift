//
//  Utils.swift
//  PracticalTest
//
//  Created by Mittal Banker on 01/10/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
class Utils{

    static func getTodayDate(date: Date) -> String{
        let fmtDate = DateFormatter()
        fmtDate.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        fmtDate.dateFormat = "dd/MM/dd hh:mm::ssZ"
        fmtDate.timeZone = TimeZone(secondsFromGMT: 0)
        let dateStr = fmtDate.string(from: date)
        return dateStr
    }

    static func write(text: String, to fileNamed: String, folder: String = "SavedFiles") {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }

}
