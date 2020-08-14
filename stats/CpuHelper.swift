//
//  CpuHelper.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation


// MARK: - CPU

/// Lists CPU usage of the mac
/// - Returns: A list containing a list with `[system, nice, idle]` CPU usage.
func getCPUUsage() -> [[CPUUsage]] {
  var sys = System()
  let cpuUsage = sys.usageCPU()
  let systemUsage = Int(cpuUsage.system)
  let niceUsage = Int(cpuUsage.nice)
  let idleUsage = Int(cpuUsage.idle)
  
  let result = [[
    CPUUsage.integer(systemUsage),
    CPUUsage.integer(niceUsage),
    CPUUsage.integer(idleUsage),
    CPUUsage.integer(0),
    CPUUsage.integer(0)
  ]]
  return result
}

// OTHER INFO

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
