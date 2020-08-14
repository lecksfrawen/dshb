//
//  UptimeHelper.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation


/// Get's the uptime
/// - Returns: uptime `"0d 0h 42m"`
func getUptime() -> String {
  let uptime: (days: Int, hrs: Int, mins: Int, secs: Int) = System.uptime()
  return "\(uptime.days)d \(uptime.hrs)h \(uptime.mins)m"
}
