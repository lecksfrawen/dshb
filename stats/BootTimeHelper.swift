//
//  BootTime.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation

// MARK: - Boottime date

//let uptime = System.uptime()
//print("\tUPTIME:          \(uptime.days)d \(uptime.hrs)h \(uptime.mins)m " +
//                            "\(uptime.secs)s")
func getBootTimeDate() throws -> Date {
  let uptime: (days: Int, hrs: Int, mins: Int, secs: Int) = System.uptime()
  let currentDate: Date = Date()
  guard let dateMinusDays: Date = Calendar.current.date(byAdding: .day, value: -uptime.days, to: currentDate),
    let dateMinusHours = Calendar.current.date(byAdding: .hour, value: -uptime.hrs, to: dateMinusDays),
    let dateMinusMinutes = Calendar.current.date(byAdding: .minute, value: -uptime.mins, to: dateMinusHours),
    let bootTimeDate = Calendar.current.date(byAdding: .second, value: -uptime.secs, to: dateMinusMinutes)
  else {
    throw SystemReadErrors.noBoottime
  }
    
  return bootTimeDate
}

/// Boottime
/// Needed for uptime status
/// Output:
/// ```json
/// "boottime":"21:48, Aug 10"
/// ```
/// - Throws: Error No boot time error
/// - Returns: bootTime Formatted string of the bottime
func getFormattedBootTimeDate() throws -> String {
  let bootTimeDate = try getBootTimeDate()
  let formatString = "HH:mm, MMM d"
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = formatString
  let bootTime: String = dateFormatter.string(from: bootTimeDate)
  return bootTime
}
