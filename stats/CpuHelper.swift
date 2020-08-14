//
//  CPUUsage.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation


// MARK: - CPU

//print("\n-- CPU --")
//print("\tPHYSICAL CORES:  \(System.physicalCores())")
//print("\tLOGICAL CORES:   \(System.logicalCores())")
//
//var sys = System()
//let cpuUsage = sys.usageCPU()
//print("\tSYSTEM:          \(Int(cpuUsage.system))%")
//print("\tUSER:            \(Int(cpuUsage.user))%")
//print("\tIDLE:            \(Int(cpuUsage.idle))%")
//print("\tNICE:            \(Int(cpuUsage.nice))%")

/// Lists CPU usage of the mac
///
/// Output:
/// ```json
/// "cpuUsage":[
///   [
///     1.9095128173673819,
///     0.0,
///     94.35262739918512
///   ]
/// ]
/// ```
/// - Returns: A list containing a list with `[system, nice, idle]` CPU usage.
func getCPUUsage() -> String {
  var sys = System()
  let cpuUsage = sys.usageCPU()
  let systemUsage = cpuUsage.system
  let niceUsage = cpuUsage.nice
  let idleUsage = cpuUsage.idle
  let cpuUsageString = """
[[\(systemUsage),\(niceUsage),\(idleUsage)]]
"""
  return cpuUsageString
}
